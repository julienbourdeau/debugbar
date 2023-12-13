require_relative 'config'
require_relative 'middlewares/track_current_request'
require_relative 'subscribers/action_controller'
require_relative 'subscribers/active_job'
require_relative 'subscribers/active_record'

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
      manifest_file = File.join(Gem.loaded_specs['debugbar'].full_gem_path, 'client', 'dist', '.vite', 'manifest.json')
      manifest = JSON.parse(File.read(manifest_file))

      Assets.js = manifest['index.html']['file']
      Assets.css = manifest['index.html']['css'].first
    end

    initializer 'debugbar.inject_middlewares' do |app|
      next unless Debugbar.config.enabled?
      app.middleware.insert_after ActionDispatch::RequestId, Debugbar::TrackCurrentRequest
    end

    initializer 'debugbar.subscribe' do
      Debugbar::ActiveRecordLogSubscriber.attach_to :active_record if Debugbar.config.active_record?
      Debugbar::ActionControllerLogSubscriber.attach_to :action_controller if Debugbar.config.action_controller?
      Debugbar::ActiveJobLogSubscriber.attach_to :active_job if Debugbar.config.active_job?
      # Debugbar::ActionViewLogSubscriber.attach_to :action_view
    end

    initializer 'debugbar.track_models' do
      next unless Debugbar.config.active_record?
      ActiveSupport.on_load(:active_record) do
        after_initialize do |model|
          Debugbar::Current.request.inc_model(model.class.name)
        end
      end
    end
  end
end
