module Debugbar
  class ActionControllerEventSubscriber
    class << self
      def start_processing(event)
        return if Debugbar::Current.ignore?

        Debugbar::Tracker.request = event.payload[:request]
      end

      def process_action(event)
        return if Debugbar::Current.ignore?

        meta = event.payload

        meta.delete :headers
        request = meta.delete :request
        response = meta.delete :response

        meta.merge!({
          duration: event.duration,
          cpu_time: event.cpu_time,
          idle_time: event.idle_time,
          allocations: event.allocations,
        })

        Debugbar::Tracker.request = request
        Debugbar::Tracker.response = response
        Debugbar::Tracker.meta = meta
      end
    end
  end
end
