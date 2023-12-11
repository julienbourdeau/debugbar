module DebugbarRb
  class Config
    attr_accessor :enabled, :prefix, :buffer_adapter, :ignore_request,
                  :active_record, :action_controller, :active_job

    alias_method :enabled?, :enabled

    def initialize(options = {})
      opt = defaults.merge options
      @enabled = opt[:enabled]
      @prefix = opt[:prefix]
      @active_record = opt[:active_record]
      @action_controller = opt[:action_controller]
      @active_job = opt[:active_job]
      @buffer_adapter = opt[:buffer_adapter]
    end

    def defaults
      {
        enabled: false,
        prefix: "/_debugbar",
        active_record: true,
        action_controller: true,
        active_job: true,
        buffer_adapter: :memory,
      }
    end

    def ignore_request?(env)
      if ignore_request.is_a? Proc
        ignore_request.call(env)
      else
        [DebugbarRb.config.prefix, "/assets"].any? { |s| env['PATH_INFO'].starts_with? s }
      end
    end

    %w(active_record action_controller active_job).each do |name|
      define_method("#{name}?") do
        @enabled && instance_variable_get("@#{name}")
      end
    end
  end
end
