require_relative 'config'
require_relative 'middlewares/track_current_request'
require_relative 'subscribers/action_controller'
require_relative 'subscribers/active_job'
require_relative 'subscribers/active_record'

module DebugbarRb
  class Engine < ::Rails::Engine
    isolate_namespace DebugbarRb

    initializer 'debugbar.init' do
      DebugbarRb::RequestBuffer.init
    end

    initializer 'debugbar.config' do |app|
      app.config.debugbar = ::DebugbarRb.config
    end

    initializer 'debugbar.assets' do
      manifest_file = File.join(Gem.loaded_specs['debugbar_rb'].full_gem_path, 'client', 'dist', '.vite', 'manifest.json')
      manifest = JSON.parse(File.read(manifest_file))

      Assets.js = manifest['index.html']['file']
      Assets.css = manifest['index.html']['css'].first
    end

    initializer 'debugbar.inject_middlewares' do |app|
      next unless DebugbarRb.config.enabled?
      app.middleware.insert_after ActionDispatch::RequestId, DebugbarRb::TrackCurrentRequest
    end

    initializer 'debugbar.subscribe' do
      DebugbarRb::ActiveRecordLogSubscriber.attach_to :active_record if DebugbarRb.config.active_record?
      DebugbarRb::ActionControllerLogSubscriber.attach_to :action_controller if DebugbarRb.config.action_controller?
      DbugbarRb::ActiveJobLogSubscriber.attach_to :active_job if DebugbarRb.config.active_job?
      # DebugbarRb::ActionViewLogSubscriber.attach_to :action_view
    end

    initializer 'debugbar.track_models' do
      next unless DebugbarRb.config.active_record?
      ActiveSupport.on_load(:active_record) do
        after_initialize do |model|
          DebugbarRb::Current.request.inc_model(model.class.name)
        end
      end
    end
  end
end
