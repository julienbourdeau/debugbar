module DebugbarRb
  class ActiveRecordLogSubscriber < ActiveSupport::LogSubscriber
    # attach_to :active_record

    class_attribute :backtrace_cleaner, default: ActiveSupport::BacktraceCleaner.new

    def sql(event)
      payload = event.payload

      return if payload[:name]&.starts_with? "SCHEMA"

      name = if payload[:async]
        "ASYNC #{payload[:name]} (#{payload[:lock_wait].round(1)}ms) (db time #{event.duration.round(1)}ms)"
      else
        "#{payload[:name] || "Unnamed"} (#{event.duration.round(1)}ms)"
      end
      name = "CACHE #{name}" if payload[:cached]

      sql = payload[:sql]&.gsub(/\/\*.*\*\//, "") # remove comments

      binds = nil
      if payload[:binds]&.any?
        casted_params = type_casted_binds(payload[:type_casted_binds])

        binds = []
        payload[:binds].each_with_index do |attr, i|
          attribute_name = if attr.respond_to?(:name)
            attr.name
          elsif attr.respond_to?(:[]) && attr[i].respond_to?(:name)
            attr[i].name
          else
            nil
          end

          filtered_params = filter(attribute_name, casted_params[i])

          binds << render_bind(attr, filtered_params)
        end
        binds = binds.inspect
        binds.prepend("  ")
      end

      CurrentRequest.add_query({
        name: name,
        sql: sql,
        duration: event.duration.round(1),
        lock_wait: payload[:lock_wait]&.round(1),
        binds: binds,
        source: query_source_location&.split(":in"),
      })
    end

    def query_source_location
      backtrace_cleaner.clean(caller(1))[1]
    end
  end
end
