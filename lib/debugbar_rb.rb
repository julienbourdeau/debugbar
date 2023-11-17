# frozen_string_literal: true

require_relative "debugbar_rb/version"

module DebugbarRb
  def self.hi
    puts "[#{VERSION}] Hello world!"
  end
end
