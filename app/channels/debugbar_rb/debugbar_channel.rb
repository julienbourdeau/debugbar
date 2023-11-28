module DebugbarRb
  class DebugbarChannel < ActionCable::Channel::Base
    def subscribed
      stream_from "debugbar_channel"
    end

    def receive(data)
      if data["clear"]
        RequestBuffer.clear!
      end

      if data["ids"].present?
        RequestBuffer.remove(data["ids"])
      end

      RequestBuffer.enable!
    end

    def unsubscribed
      RequestBuffer.disable!
    end
  end
end
