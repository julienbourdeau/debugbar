module Debugbar
  class HttpLogger < ::Logger
    def initialize(min_level= 2)
      @min_level = min_level
    end

    def log(_level, json_str)
      # We normally rely on the Tracker to know if the current request is set or nil and log an error to STDOUT,
      # but in this case, it happens so often that the logs are annoying.
      # In ActiveCable, only the first call goes through the Rake middleware, so every following communication
      # doesn't go through TrackCurrentRequest, which initializes the request.
      return if ::Debugbar::Current.request.nil?

      log = JSON.parse(json_str)
      req = HttpRequest.new(log["method"], log["url"], log["request_headers"], log["request_body"])
      res = HttpResponse.new(log["response_code"], log["response_headers"], log["response_body"])
      Debugbar::Tracker.add_http_call(SecureRandom.hex(4), req, res, benchmark: log['benchmark'])
    end
  end
end
