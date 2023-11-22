module DebugbarRb
  class ActionControllerLogSubscriber < ActiveSupport::LogSubscriber
    # attach_to :action_controller

    def start_processing(event)
      Acc.request = event.payload[:request]
    end

    def process_action(event)
      payload = event.payload
      response = payload.delete :response

      Acc.response = response
      Acc.meta = payload
    end
  end
end
