module DebugbarRb
  class RequestMetrics
    def initialize(app)
      @app = app
    end

    def call(env)
      DebugbarRb::Acc.init(env['action_dispatch.request_id'])
      @app.call(env)
      # Save data here before it's returned?
    end
  end

end
