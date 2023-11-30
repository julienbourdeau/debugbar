module DebugbarRb
  class TrackCurrentRequest
    def initialize(app)
      @app = app
    end

    def call(env)
      DebugbarRb::CurrentRequest.new_request!(env['action_dispatch.request_id'])

      res = @app.call(env)

      # TODO: Add proper way exclude requests
      # Can check env['PATH_INFO'] ~= /assets/ like QuietAssets middleware
      # can be in config
      # The debugbar assets should be ignored
      if DebugbarRb::CurrentRequest.meta && env['PATH_INFO'] !~ /^\/(assets|__debugbar)/
        RequestBuffer.push(DebugbarRb::CurrentRequest.pop!)
      end

      res
    end
  end

end
