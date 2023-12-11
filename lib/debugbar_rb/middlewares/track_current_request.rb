module DebugbarRb
  class TrackCurrentRequest
    def initialize(app)
      @app = app
    end

    def call(env)
      DebugbarRb::Current.ignore = DebugbarRb.config.ignore_request?(env)

      if DebugbarRb::Current.ignore?
        DebugbarRb::Current.null_request!
        return @app.call(env)
      end

      DebugbarRb::Current.new_request!(env['action_dispatch.request_id'])

      res = @app.call(env)

      # TODO: Remove this if meta
      if DebugbarRb::Current.request.meta
        RequestBuffer.push(DebugbarRb::Current.pop_request!)

        if DebugbarRb.connected?
          data = RequestBuffer.all.map(&:to_h)
          ActionCable.server.broadcast("debugbar_channel", data)
        end
      end

      res
    end
  end

end
