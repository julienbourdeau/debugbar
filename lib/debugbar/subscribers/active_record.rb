# frozen_string_literal: true

module Debugbar
  class ActiveRecordEventSubscriber
    class_attribute :backtrace_cleaner, default: ActiveSupport::BacktraceCleaner.new

    class << self
      def sql(event)
        return if Debugbar::Current.ignore?

        payload = event.payload

        return if payload[:name]&.starts_with? "SCHEMA"

        title = if payload[:async]
          "ASYNC #{payload[:name]} (#{payload[:lock_wait].round(1)}ms) (db time #{event.duration.round(1)}ms)"
        else
          "#{payload[:name] || "Unnamed"} (#{event.duration.round(1)}ms)"
        end
        title = "CACHE #{title}" if payload[:cached]

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

        Current.request.add_query({
          id: event.transaction_id,
          title: title,
          name: payload[:name],
          sql: sql,
          cached: payload[:cached].present?,
          async: payload[:async],
          duration: event.duration.round(1),
          lock_wait: payload[:lock_wait]&.round(1),
          binds: binds,
          source: query_source_location&.split(":in"),
        })
      end

      def query_source_location
        backtrace_cleaner.clean(caller(3))[0]
      end
    end
  end
end
