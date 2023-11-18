# frozen_string_literal: true

module DebugbarRb
  autoload :VERSION, "debugbar_rb/version"
  autoload :Acc, "debugbar_rb/acc"


  def self.hi
    puts "[#{VERSION}] Hello world!"
  end
end

require 'debugbar_rb/railtie'
