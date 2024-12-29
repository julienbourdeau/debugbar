module Debugbar
  class TrackCurrentRequest
    def initialize(app)
      @app = app
    end

    def call(env)
      # we don't check if debugbar is enabled because this middleware is only added when it is

      # Set `ignore` attribute to reuse it anywhere
      Debugbar::Current.ignore = Debugbar.config.ignore_request?(env)

      return @app.call(env) if Debugbar::Current.ignore?

      Debugbar::Current.new_request!(SecureRandom.uuid)

      res = @app.call(env)

      # TODO: Remove this if statement?
      # We check meta because the frontend doesn't support request without meta yet.
      # It might happen with ActionController::Live where the following code
      # will run BEFORE ActionControllerEventSubscriber.process_action is called
      if Debugbar::Current.request&.meta
        RequestBuffer.push(Debugbar::Current.pop_request!)

        # TODO: Refactor since not having ActionCable might be more common than I thought
        if defined?(ActionCable)
          ActionCable.server.broadcast("debugbar_channel", RequestBuffer.to_h)
        end
      end

      res
    end
  end

end
