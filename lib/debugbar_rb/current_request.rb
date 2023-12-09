# frozen_string_literal: true


module DebugbarRb
  class CurrentRequest
    class << self
      def new_request!(request_id)
        self.current = Request.new(request_id)
      end

      def pop!
        current.tap { self.current = nil }
      end

      def to_json
        current.to_json
      end

      private

      def method_missing(symbol, *args)
        return if current.nil?
        if current.respond_to?(symbol)
          current.send(symbol, *args)
        else
          super
        end
      end

      def current
        Thread.current[:debugbar_request]
      end

      def current=(request)
        Thread.current[:debugbar_request] = request
      end
    end
  end
end
