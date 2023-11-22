module DebugbarRb
  class RequestMetrics
    def initialize(app)
      @app = app
    end

    def call(env)
      DebugbarRb::Acc.init(env['action_dispatch.request_id'])

      res = @app.call(env)

      if DebugbarRb::Acc.meta
        path = "./_requests/#{env['action_dispatch.request_id']}.json"
        File.write(path, DebugbarRb::Acc.to_json)
      end

      res
    end
  end

end
