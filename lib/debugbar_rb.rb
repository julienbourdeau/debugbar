# frozen_string_literal: true

module DebugbarRb
  autoload :VERSION, "debugbar_rb/version"
  autoload :Assets, "debugbar_rb/assets"
  autoload :Current, "debugbar_rb/current"
  autoload :Request, "debugbar_rb/request"
  autoload :NullRequest, "debugbar_rb/null_request"
  autoload :RequestBuffer, "debugbar_rb/buffers/request_buffer"

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
  end
end

require 'debugbar_rb/engine'
