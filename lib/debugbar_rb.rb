# frozen_string_literal: true

module DebugbarRb
  autoload :VERSION, "debugbar_rb/version"
  autoload :CurrentRequest, "debugbar_rb/current_request"
  autoload :Request, "debugbar_rb/request"
  autoload :RequestBuffer, "debugbar_rb/request_buffer"
end

require 'debugbar_rb/engine'
