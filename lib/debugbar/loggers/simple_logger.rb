module Debugbar
  class SimpleLogger < ::Logger
    def initialize(min_level= 2)
      @min_level = min_level
    end

    def add(severity, message = nil, progname = nil)
      # We normally rely on the Tracker to know if the current request is set or nil and log an error to STDOUT,
      # but in this case, it happens so often that the logs are annoying.
      # In ActiveCable, only the first call goes through the Rake middleware, so every following communication
      # doesn't go through TrackCurrentRequest, which initializes the request.
      return if ::Debugbar::Current.request.nil?

      return if severity < @min_level

      if message.nil?
        if block_given?
          message = yield
        else
          message = progname
          progname = nil
        end
      end

      Debugbar::Tracker.add_log({
        time: Time.now.strftime(Debugbar::TIME_FORMAT),
        severity: severity,
        severity_label: SEV_LABEL[severity],
        message: message,
        progname: progname,
      })
    end
  end
end
