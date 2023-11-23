module DebugbarRb
  class TrackCurrentRequest
    def initialize(app)
      @app = app
    end

    def call(env)
      DebugbarRb::CurrentRequest.new_request!(env['action_dispatch.request_id'])

      res = @app.call(env)

      if DebugbarRb::CurrentRequest.meta
        path = "./_requests/#{env['action_dispatch.request_id']}.json"
        File.write(path, DebugbarRb::CurrentRequest.to_json)

        RequestCollection.add(DebugbarRb::CurrentRequest.pop!)
      end

      res
    end
  end

end
