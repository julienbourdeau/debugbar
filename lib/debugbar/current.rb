# frozen_string_literal: true

module Debugbar
  class Current < ActiveSupport::CurrentAttributes
    attribute :request
    attribute :ignore

    alias_method :ignore?, :ignore

    def new_request!(request_id)
      self.request = Request.new(request_id)
    end

    def pop_request!
      request.tap { self.request = nil }
    end
  end
end
