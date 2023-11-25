require_relative 'middlewares/track_current_request'
require_relative 'subscribers/active_record'
require_relative 'subscribers/action_controller'

module DebugbarRb
  class Engine < ::Rails::Engine
    isolate_namespace DebugbarRb

    initializer 'debugbar.init' do
      DebugbarRb::RequestBuffer.init
    end

    initializer 'debugbar.inject_middlewares' do |app|
      app.middleware.insert_after ActionDispatch::RequestId, DebugbarRb::TrackCurrentRequest
    end

    initializer 'debugbar.subscribe' do
      DebugbarRb::ActiveRecordLogSubscriber.attach_to :active_record
      DebugbarRb::ActionControllerLogSubscriber.attach_to :action_controller
      # DebugbarRb::ActionViewLogSubscriber.attach_to :action_view
    end

    initializer 'debugbar.track_models' do
      if defined? ActiveRecord::Base
        ActiveRecord::Base.after_initialize do |model|
          DebugbarRb::CurrentRequest.inc_model(model.class.name)
        end
      end
    end
  end
end
