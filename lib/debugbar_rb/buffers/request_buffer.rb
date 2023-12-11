module DebugbarRb
  class RequestBuffer
    class << self
      def init(adapter)
        @enabled = false
        @adapter = adapter
      end

      def enable!
        @enabled = true
        send_all
      end

      def disable!
        @enabled = false
      end

      def send_all
        data = @collection.values.map(&:to_h)
        ActionCable.server.broadcast("debugbar_channel", data)
      end

      %w(push each all remove clear!).each do |name|
        define_method(name) do |*args, &block|
          ret = @adapter.send(name, *args, &block)
          ret == :self ? self : ret
        end
      end
    end
  end
end
