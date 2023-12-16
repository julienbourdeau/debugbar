module Debugbar
  class ActiveSupportEventSubscriber
    class << self
      def cache(event)
        evt = event.payload
        evt[:name] = event.name
        evt[:transaction_id] = event.transaction_id
        evt[:time] = event.time

        Current.request.add_cache evt
      end
    end
  end
end
