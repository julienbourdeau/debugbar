module DebugbarRb
  class ActionControllerLogSubscriber < ActiveSupport::LogSubscriber
    def start_processing(event)
      CurrentRequest.request = event.payload[:request]
    end

    def process_action(event)
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

      CurrentRequest.response = response
      CurrentRequest.meta = meta
    end
  end
end
