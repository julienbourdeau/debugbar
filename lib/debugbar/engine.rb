require_relative 'config'
require_relative 'middlewares/quiet_routes'
require_relative 'middlewares/track_current_request'
require_relative '../../app/helpers/debugbar/tag_helpers'

module Debugbar
  class Engine < ::Rails::Engine
    isolate_namespace Debugbar

    initializer 'debugbar.config' do |app|
      app.config.debugbar = ::Debugbar.config
    end

    initializer 'debugbar.init' do |app|
      # Display error message if running in multi-process mode without proper configuration
      if ENV["WEB_CONCURRENCY"].to_i > 1
        cache_nok = %i[null_store memory_store].include?(Rails.configuration.cache_store.first.to_sym)
        action_cable_nok = ActionCable.server.config.cable[:adapter].to_s == "async"
        adapter_nok = app.config.debugbar.buffer_adapter != :cache

        if cache_nok || action_cable_nok || adapter_nok
          msg = [
            "############################################################################################################",
            "# Debugbar: You are using a multi-process server configuration (like Puma in cluster mode)",
            "# Debugbar: You can use puma in single mode by setting the environment variable WEB_CONCURRENCY to 0",
            "# Debugbar: If you want to use multiple processes, you must ensure that the following conditions are met:",
            "# Debugbar: \t Use a persistent cache store (like files or database) in your Application config",
            "# Debugbar: \t Use a persistent adapter for ActionCable (like Redis or SolidCable)",
            "# Debugbar: \t Use the :cache buffer_adapter in config/initializers/debugbar.rb",
            "############################################################################################################",
          ]

          logger = Logger.new(STDOUT)
          msg.each { |m| logger.warn(m) }
        end
      end

      adapter = case(app.config.debugbar.buffer_adapter)
      when :cache
        require_relative 'buffers/cache_buffer'
        CacheBuffer.new
      when :memory
        require_relative 'buffers/memory_buffer'
        MemoryBuffer.new
      when :null
        require_relative 'buffers/null_buffer'
        NullBuffer.new
      else
        throw "Invalid RequestBuffer adapter"
      end

      Debugbar::RequestBuffer.init(adapter)
    end

    initializer 'debugbar.helper' do
      ActiveSupport.on_load(:action_controller) do
        ActionController::Base.helper(Debugbar::TagHelpers)
      end

      ActiveSupport.on_load(:action_view) do
        include Debugbar::TagHelpers
      end
    end

    initializer 'debugbar.inject_middlewares' do |app|
      next unless Debugbar.config.enabled?
      app.middleware.insert_after ActionDispatch::Executor, Debugbar::TrackCurrentRequest
      app.middleware.insert_after Debugbar::TrackCurrentRequest, Debugbar::QuietRoutes
    end

    initializer 'debugbar.subscribe' do
      if Debugbar.config.active_record?
        require_relative 'subscribers/active_record'
        subscribe "Debugbar::ActiveRecordEventSubscriber" => "sql.active_record"
      end

      if Debugbar.config.action_controller?
        require_relative 'subscribers/action_controller'
        subscribe "Debugbar::ActionControllerEventSubscriber" => %w[
          start_processing.action_controller process_action.action_controller
        ]
      end

      if Debugbar.config.active_job?
        require_relative 'subscribers/active_job'
        subscribe "Debugbar::ActiveJobEventSubscriber" => ["enqueue.active_job", "enqueue_at.active_job"]
      end

      require_relative 'subscribers/active_support'
      subscribe "Debugbar::ActiveSupportEventSubscriber.cache" => %w(
        cache_read.active_support
        cache_generate.active_support
        cache_fetch_hit.active_support
        cache_write.active_support
        cache_delete.active_support
        cache_exist?.active_support
      )
    end

    initializer 'debugbar.track_models' do
      next unless Debugbar.config.active_record?
      ActiveSupport.on_load(:active_record) do
        after_initialize do |model|
          Debugbar::Tracker.inc_model(model.class.name)
        end
      end
    end

    def subscribe(config)
      config.each do |subscriber, event_names|
        event_names = Array.wrap(event_names)
        class_name, class_method_name = subscriber.split('.')
        event_names.each do |name|
          method_name = class_method_name || name.split('.').first
          ActiveSupport::Notifications.subscribe name do |event|
            class_name.constantize.send method_name, event
          end
        end
      end
    end
  end
end
