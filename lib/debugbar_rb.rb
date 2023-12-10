# frozen_string_literal: true

module DebugbarRb
  autoload :VERSION, "debugbar_rb/version"
  autoload :Assets, "debugbar_rb/assets"
  autoload :Current, "debugbar_rb/current"
  autoload :Request, "debugbar_rb/request"
  autoload :RequestBuffer, "debugbar_rb/request_buffer"
end

require 'debugbar_rb/engine'
