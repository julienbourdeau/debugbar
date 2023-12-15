# frozen_string_literal: true

module Debugbar
  autoload :VERSION, "debugbar/version"
  autoload :Assets, "debugbar/assets"
  autoload :Current, "debugbar/current"
  autoload :Request, "debugbar/request"
  autoload :NullRequest, "debugbar/null_request"
  autoload :RequestBuffer, "debugbar/buffers/request_buffer"

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
      if Current.request.nil?
        puts "The current request is not set yet. Printing to STDOUT instead."
        puts msg, extra
      else
        Current.request.add_msg(msg, extra)
      end
    end
  end
end

require 'debugbar/engine'
