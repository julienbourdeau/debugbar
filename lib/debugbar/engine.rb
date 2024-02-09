require_relative 'config'
require_relative 'middlewares/track_current_request'

module Debugbar
  class Engine < ::Rails::Engine
    isolate_namespace Debugbar

    initializer 'debugbar.config' do |app|
      app.config.debugbar = ::Debugbar.config
    end

    initializer 'debugbar.init' do |app|
      adapter = case(app.config.debugbar.buffer_adapter)
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

    # TODO: IMPROVE BEFORE RELEASE
    initializer 'debugbar.assets' do
      dist = File.join(Gem.loaded_specs['debugbar'].full_gem_path, 'client', 'dist')
      manifest_file =  File.join(dist, '.vite', 'manifest.json')
      manifest = JSON.parse(File.read(manifest_file))

      Debugbar.js_file = File.join(dist, manifest['src/main.ts']['file'])
    end

    initializer 'debugbar.inject_middlewares' do |app|
      next unless Debugbar.config.enabled?
      app.middleware.insert_after ActionDispatch::RequestId, Debugbar::TrackCurrentRequest
    end

    # initializer 'debugbar.features' do |app|
    #   if Debugbar.config.use_logger?
    #     # require_relative 'loggers/simple_logger'
    #     app.config.logger = Debugbar::SimpleLogger.new(Debugbar.config.min_log_level)
    #   end
    # end

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
          Debugbar::Current.request.inc_model(model.class.name)
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
