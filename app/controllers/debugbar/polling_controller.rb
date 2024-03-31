module Debugbar
  class PollingController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:confirm], if: -> { self.respond_to?(:verify_authenticity_token, true) }
    before_action :cors_set_access_control_headers

    def poll
      render json: RequestBuffer.all.map(&:to_h)
    end

    def confirm
      RequestBuffer.remove params[:ids]
      head :ok
    end

    private

    def cors_set_access_control_headers
      response.headers['Access-Control-Allow-Origin'] = '*'
      response.headers['Access-Control-Allow-Headers'] = 'Content-Type'
      response.headers['Access-Control-Allow-Methods'] = 'POST, GET'
    end
  end
end
