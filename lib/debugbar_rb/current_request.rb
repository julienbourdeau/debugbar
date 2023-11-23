# frozen_string_literal: true


module DebugbarRb
  class CurrentRequest
    class << self
      delegate_missing_to :@current

      def new_request!(request_id)
        @current = Request.new(request_id)
      end

      def pop!
        @current.tap { @current = nil } # Not sure here. We might want to init a new empty request.
      end

      def to_json
        @current.to_json
      end
    end
  end
end
