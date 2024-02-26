module Debugbar
  class TrackCurrentRequest
    def initialize(app)
      @app = app
    end

    def call(env)
      Debugbar::Current.ignore = Debugbar.config.ignore_request?(env)

      return @app.call(env) if Debugbar::Current.ignore?

      Debugbar::Current.new_request!(SecureRandom.uuid)

      res = @app.call(env)

      # TODO: Remove this if statement?
      # We check meta because the frontend doesn't support request without meta yet.
      # It might happen with ActionController::Live where the following code
      # will run BEFORE ActionControllerEventSubscriber.process_action is called
      if Debugbar::Current.request&.meta
        # filename = "#{Time.now.to_i}--#{Debugbar::Current.request.meta.dig(:params, :controller)}_#{Debugbar::Current.request.meta.dig(:params, :action).gsub('/', '_')}.json"
        # File.open(Rails.root.join('_requests', filename), "w") do |f|
        #   f.write(Debugbar::Current.request.to_json)
        # end

        RequestBuffer.push(Debugbar::Current.pop_request!)

        if Debugbar.connected?
          data = RequestBuffer.all.map(&:to_h)
          ActionCable.server.broadcast("debugbar_channel", data)
        end
      end

      res
    end
  end

end
