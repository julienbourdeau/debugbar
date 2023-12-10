# frozen_string_literal: true

module DebugbarRb
  class Current < ActiveSupport::CurrentAttributes
    attribute :request

    def new_request!(request_id)
      self.request = Request.new(request_id)
    end

    def pop_request!
      request.tap { self.request = nil }
    end
  end
end
