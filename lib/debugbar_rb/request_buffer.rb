module DebugbarRb
  class RequestBuffer
    class << self
      def init
        @enabled = false
        @collection = {}
      end

      def enable!
        @enabled = true
        send_all
      end

      def disable!
        @enabled = false
      end

      def push(request)
        @collection[request.id] = request
        send_all if @enabled
        self
      end

      def send_all
        data = @collection.values.map(&:to_h)
        ActionCable.server.broadcast("debugbar_channel", data)
      end

      def remove(ids)
        ids = Array.wrap(ids)
        ids.each do |id|
          @collection.delete(id)
        end
        self
      end

      def each(&block)
        @collection.each(&block)
        self
      end

      def clear!
        @collection = {}
        self
      end
    end
  end
end
