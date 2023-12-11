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

      DebugbarRb.connect!

      data = RequestBuffer.all.map(&:to_h)
      ActionCable.server.broadcast("debugbar_channel", data)
    end

    def unsubscribed
      DebugbarRb.disconnect!
    end
  end
end
