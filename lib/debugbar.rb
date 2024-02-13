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
          if Current.request.nil?
            # TODO: Much, much better logging needed
            puts "The current request is not set yet. Was trying to set #{m}=[#{val.class.name}]."
          else
            Current.request.send("#{m}=", val)
          end
        end
      end

      METHODS.each do |m|
        define_method(m) do |*args, &block|
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

      def msg(msg, *extra)
        if Current.request.nil?
          puts "The current request is not set yet. Printing to STDOUT instead."
          puts msg, extra
        else
          Current.request.add_msg(msg, extra)
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

    def connect!
      @connected = true
    end

    def disconnect!
      @connected = false
    end

    def connected?
      @connected
    end

    def msg(msg, *extra)
      Tracker.msg(msg, *extra)
    end
  end
end

require 'debugbar/engine'
