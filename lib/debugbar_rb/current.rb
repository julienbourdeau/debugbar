# frozen_string_literal: true

module DebugbarRb
  class Current < ActiveSupport::CurrentAttributes
    attribute :request
    attribute :ignore

    alias_method :ignore?, :ignore

    def null_request!
      self.request = NullRequest.new
    end

    def new_request!(request_id)
      self.request = Request.new(request_id)
    end

    def pop_request!
      request.tap { self.request = NullRequest.new }
    end
  end
end
