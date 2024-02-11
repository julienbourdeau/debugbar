module Debugbar
  class SimpleLogger < ::Logger
    def initialize(min_level= 2)
      @min_level = min_level
    end

    def add(severity, message = nil, progname = nil)
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
