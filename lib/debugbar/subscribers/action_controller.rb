module Debugbar
  class ActionControllerEventSubscriber
    class << self
      def start_processing(event)
        return if Debugbar::Current.ignore?

        Current.request.request = event.payload[:request]
      end

      def process_action(event)
        return if Debugbar::Current.ignore?

        meta = event.payload

        meta.delete :request
        meta.delete :headers
        response = meta.delete :response

        meta.merge!({
          duration: event.duration,
          cpu_time: event.cpu_time,
          idle_time: event.idle_time,
          allocations: event.allocations,
        })

        Current.request.response = response
        Current.request.meta = meta
      end
    end
  end
end
