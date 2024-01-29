module Debugbar
  class Config
    attr_accessor :enabled, :prefix, :buffer_adapter, :ignore_request,
                  :active_record, :action_controller, :active_job,
                  :min_log_level

    alias_method :enabled?, :enabled

    def initialize(options = {})
      opt = defaults.merge options
      @enabled = opt[:enabled] && !defined?(Rails::Console)
      @prefix = opt[:prefix]
      @active_record = opt[:active_record]
      @action_controller = opt[:action_controller]
      @active_job = opt[:active_job]
      @min_log_level = opt[:min_log_level]
      @buffer_adapter = opt[:buffer_adapter]
    end

    def defaults
      {
        enabled: false,
        prefix: "/_debugbar",
        active_record: true,
        action_controller: true,
        active_job: true,
        min_log_level: -1,
        buffer_adapter: :memory,
      }
    end

    def ignore_request?(env)
      if ignore_request.is_a? Proc
        ignore_request.call(env)
      else
        [Debugbar.config.prefix, "/assets"].any? { |s| env['PATH_INFO'].start_with? s }
      end
    end

    def use_logger?
      @enabled && @min_log_level >= 0
    end

    %w(active_record action_controller active_job).each do |name|
      define_method("#{name}?") do
        @enabled && instance_variable_get("@#{name}")
      end
    end
  end
end
