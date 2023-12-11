# frozen_string_literal: true

module Debugbar
  class ActiveJobLogSubscriber < ActiveSupport::LogSubscriber # :nodoc:
    class_attribute :backtrace_cleaner, default: ActiveSupport::BacktraceCleaner.new

    def enqueue(event)
      return if Debugbar::Current.ignore?

      job = event.payload[:job]
      ex = event.payload[:exception_object] || job.enqueue_error

      logs = []
      logs << if ex
        "Failed enqueuing #{job.class.name} to #{queue_name(event)}: #{ex.class} (#{ex.message})"
      elsif event.payload[:aborted]
        "Failed enqueuing #{job.class.name} to #{queue_name(event)}, a before_enqueue callback halted the enqueuing execution."
      else
        "Enqueued #{job.class.name} (Job ID: #{job.job_id}) to #{queue_name(event)}" + args_info(job)
      end
      logs << log_enqueue_source

      Current.request.add_job({
        id: job.job_id,
        class: job.class.name,
        queue: queue_name(event),
        args: job.arguments.map { |arg| format(arg) },
        successfully_enqueued: job.successfully_enqueued?,
        scheduled_at: scheduled_at(job),
        logs: logs,
      })
    end
    # subscribe_log_level :enqueue, :info # ???

    def enqueue_at(event)
      return if Debugbar::Current.ignore?

      job = event.payload[:job]
      ex = event.payload[:exception_object] || job.enqueue_error

      logs = []
      logs << if ex
        "Failed enqueuing #{job.class.name} to #{queue_name(event)}: #{ex.class} (#{ex.message})"
      elsif event.payload[:aborted]
        "Failed enqueuing #{job.class.name} to #{queue_name(event)}, a before_enqueue callback halted the enqueuing execution."
      else
        "Enqueued #{job.class.name} (Job ID: #{job.job_id}) to #{queue_name(event)} at #{scheduled_at(job)}" + args_info(job)
      end
      logs << log_enqueue_source

      Current.request.add_job({
        id: job.job_id,
        class: job.class.name,
        queue: queue_name(event),
        args: job.arguments.map { |arg| format(arg) },
        successfully_enqueued: job.successfully_enqueued?,
        scheduled_at: scheduled_at(job),
        logs: logs,
      })
    end
    # subscribe_log_level :enqueue_at, :info

    # def enqueue_all(event)
    #   info do
    #     jobs = event.payload[:jobs]
    #     adapter = event.payload[:adapter]
    #     enqueued_count = event.payload[:enqueued_count]
    #
    #     if enqueued_count == jobs.size
    #       enqueued_jobs_message(adapter, jobs)
    #     elsif jobs.any?(&:successfully_enqueued?)
    #       enqueued_jobs = jobs.select(&:successfully_enqueued?)
    #
    #       failed_enqueue_count = jobs.size - enqueued_count
    #       if failed_enqueue_count == 0
    #         enqueued_jobs_message(adapter, enqueued_jobs)
    #       else
    #         "#{enqueued_jobs_message(adapter, enqueued_jobs)}. "\
    #           "Failed enqueuing #{failed_enqueue_count} #{'job'.pluralize(failed_enqueue_count)}"
    #       end
    #     else
    #       failed_enqueue_count = jobs.size - enqueued_count
    #       "Failed enqueuing #{failed_enqueue_count} #{'job'.pluralize(failed_enqueue_count)} "\
    #         "to #{ActiveJob.adapter_name(adapter)}"
    #     end
    #   end
    # end
    # # subscribe_log_level :enqueue_all, :info

    private
    def queue_name(event)
      ActiveJob.adapter_name(event.payload[:adapter]) + "(#{event.payload[:job].queue_name})"
    end

    def args_info(job)
      if job.class.log_arguments? && job.arguments.any?
        " with arguments: " +
          job.arguments.map { |arg| format(arg).inspect }.join(", ")
      else
        ""
      end
    end

    def format(arg)
      case arg
      when Hash
        arg.transform_values { |value| format(value) }
      when Array
        arg.map { |value| format(value) }
      when GlobalID::Identification
        arg.to_global_id rescue arg
      else
        arg
      end
    end

    def scheduled_at(job)
      Time.at(job.scheduled_at).utc if job.scheduled_at
    end

    def logger
      ActiveJob::Base.logger
    end

    def info(progname = nil, &block)
      return unless super

      if ActiveJob.verbose_enqueue_logs
        log_enqueue_source
      end
    end

    def error(progname = nil, &block)
      return unless super

      if ActiveJob.verbose_enqueue_logs
        log_enqueue_source
      end
    end

    def log_enqueue_source
      extract_enqueue_source_location(caller)
    end

    def extract_enqueue_source_location(locations)
      backtrace_cleaner.clean(locations.lazy).first
    end

    def enqueued_jobs_message(adapter, enqueued_jobs)
      enqueued_count = enqueued_jobs.size
      job_classes_counts = enqueued_jobs.map(&:class).tally.sort_by { |_k, v| -v }
      "Enqueued #{enqueued_count} #{'job'.pluralize(enqueued_count)} to #{ActiveJob.adapter_name(adapter)}"\
        " (#{job_classes_counts.map { |klass, count| "#{count} #{klass}" }.join(', ')})"
    end
  end
end
