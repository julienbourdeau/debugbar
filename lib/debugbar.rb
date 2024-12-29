# frozen_string_literal: true

module Debugbar
  autoload :VERSION, "debugbar/version"
  autoload :Current, "debugbar/current"
  autoload :Request, "debugbar/request"
  autoload :RequestBuffer, "debugbar/buffers/request_buffer"
  autoload :SimpleLogger, "debugbar/loggers/simple_logger"

  TIME_FORMAT = "%H:%M:%S.%L"

  module Tracker
    class << self
      SETTERS = %i[request response headers meta].freeze
      METHODS = %i[inc_model add_query add_job add_cache add_log].freeze

      SETTERS.each do |m|
        define_method("#{m}=") do |val|
          return if Debugbar::Current.ignore?

          if Current.request
            return Current.request.send("#{m}=", val)
          end

          if Current.request.nil? && ENV["DEBUGBAR_VERBOSE_MODE"] == "true"
            # TODO: Much, much better logging needed
            puts "The current request is not set yet. Was trying to set #{m} = #{val.class.name}."
            pp val
            nil
          end
        end
      end

      METHODS.each do |m|
        define_method(m) do |*args, &block|
          return if Debugbar::Current.ignore?

          if Current.request
            return Current.request.send(m, *args, &block)
          end

          if Current.request.nil? && ENV["DEBUGBAR_VERBOSE_MODE"] == "true"
            puts "The current request is not set yet. Was trying to call #{m}(#{args.map{ _1.class.name}.join(',')})."
            pp args
            nil
          end
        end
      end

      def msg(msg, extra, source)
        if Current.request.nil?
          puts "The current request is not set yet. Printing to STDOUT instead."
          puts msg, extra, source
        else
          Current.request.add_msg(msg, extra, source)
        end
      end
    end
  end

  include Tracker

  class << self
    def config
      @config ||= Config.new(enabled: true)
    end

    def configure
      yield config
    end

    def msg(msg, *extra)
      source = caller.first&.split(":in")&.map { |s| s.delete_prefix("#{Rails.root}/").strip.tr("`'", '' ) }
      Tracker.msg(msg, extra, source)
    end
  end
end

require 'debugbar/engine'
