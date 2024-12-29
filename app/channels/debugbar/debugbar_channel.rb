module Debugbar
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

      ActionCable.server.broadcast("debugbar_channel", RequestBuffer.to_h)
    end

    def unsubscribed
      # Nothing to do
    end
  end
end
