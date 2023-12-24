module Debugbar
  class ActiveSupportEventSubscriber
    class << self
      def cache(event)
        evt = event.payload
        evt[:name] = event.name
        evt[:transaction_id] = event.transaction_id
        evt[:time] = Time.at(event.time).strftime(Debugbar::TIME_FORMAT)
        evt[:label] = case event.name
          when "cache_read.active_support"
            "read"
          when "cache_generate.active_support"
            "generate"
          when "cache_fetch_hit.active_support"
            "fetch hit"
          when "cache_write.active_support"
            "write"
          when "cache_delete.active_support"
            "delete"
          when "cache_exist?.active_support"
            "exist?"
          else
            "unknown"
          end

        Current.request.add_cache evt
      end
    end
  end
end
