module DebugbarRb
  class Config
    attr_accessor :enabled, :buffer_adapter,
                  :active_record, :action_controller, :active_job

    alias_method :enabled?, :enabled

    def initialize(options = {})
      @enabled = options.fetch(:enabled, false)
      @active_record = options.fetch(:active_record, true)
      @action_controller = options.fetch(:action_controller, true)
      @active_job = options.fetch(:active_job, true)
      @buffer_adapter = options.fetch(:buffer_adapter, :memory)
    end

    %w(active_record action_controller active_job).each do |name|
      define_method("#{name}?") do
        @enabled && instance_variable_get("@#{name}")
      end
    end
  end
end
