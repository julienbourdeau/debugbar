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

      Debugbar.connect!

      data = RequestBuffer.all.map(&:to_h)
      ActionCable.server.broadcast("debugbar_channel", data)
    end

    def unsubscribed
      Debugbar.disconnect!
    end
  end
end
