module DebugbarRb
  class DebugbarChannel < ActionCable::Channel::Base
    def subscribed
      stream_from "debugbar_channel"
    end

    def receive(data)
      RequestBuffer.remove(data["ids"])
      RequestBuffer.enable!
    end

    def unsubscribed
      RequestBuffer.disable!
      RequestBuffer.clear!
    end
  end
end
