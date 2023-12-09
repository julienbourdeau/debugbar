module DebugbarRb
  class Config
    attr_accessor :enabled

    def initialize(options = {})
      @enabled = options.fetch(:enabled, false)
    end

    def enabled?
      @enabled
    end
  end
end
