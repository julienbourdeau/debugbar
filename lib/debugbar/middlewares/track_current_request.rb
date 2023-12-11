module Debugbar
  class TrackCurrentRequest
    def initialize(app)
      @app = app
    end

    def call(env)
      Debugbar::Current.ignore = Debugbar.config.ignore_request?(env)

      if Debugbar::Current.ignore?
        Debugbar::Current.null_request!
        return @app.call(env)
      end

      Debugbar::Current.new_request!(env['action_dispatch.request_id'])

      res = @app.call(env)

      # TODO: Remove this if meta
      if Debugbar::Current.request.meta
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
