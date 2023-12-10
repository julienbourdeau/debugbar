module DebugbarRb
  class TrackCurrentRequest
    def initialize(app)
      @app = app
    end

    def call(env)
      DebugbarRb::Current.new_request!(env['action_dispatch.request_id'])

      res = @app.call(env)

      # TODO: Add proper way exclude requests
      # Can check env['PATH_INFO'] ~= /assets/ like QuietAssets middleware
      # can be in config
      # The debugbar assets should be ignored
      if DebugbarRb::Current.request.meta && env['PATH_INFO'] !~ /^\/(assets|__debugbar)/
        RequestBuffer.push(DebugbarRb::Current.pop_request!)
      end

      res
    end
  end

end
