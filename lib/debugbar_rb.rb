# frozen_string_literal: true

module DebugbarRb
  autoload :VERSION, "debugbar_rb/version"
  autoload :CurrentRequest, "debugbar_rb/current_request"
  autoload :Request, "debugbar_rb/request"
  autoload :RequestCollection, "debugbar_rb/request_collection"
end

require 'debugbar_rb/engine'
