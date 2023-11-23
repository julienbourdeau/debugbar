module DebugbarRb
  class RequestCollection
    class << self
      def add(request)
        @collection ||= {}
        @collection[request.id] = request
      end

      def clear!
        @collection = {}
      end
    end
  end
end
