module Debugbar
  class RequestBuffer
    class << self
      def init(adapter)
        @adapter = adapter
      end

      def push(request)
        @adapter.push(request)
        nil # Why not return self?
      end

      def remove(ids)
        @adapter.remove(ids)
        self
      end

      def to_h
        @adapter.to_h
      end

      def each(&block)
        @adapter.each(&block)
        self
      end

      def clear!
        @adapter.clear!
        self
      end
    end
  end
end
