# frozen_string_literal: true

require 'rails/railtie'
require_relative 'middlewares/request_metrics'
require_relative 'subscribers/active_record'
require_relative 'subscribers/action_controller'

module DebugbarRb
  class Railtie < ::Rails::Railtie
    initializer 'debugbar.inject_middlewares' do |app|
      app.middleware.insert_after ActionDispatch::RequestId, DebugbarRb::RequestMetrics
    end

    initializer 'debugbar.subscribe' do
      DebugbarRb::ActiveRecordLogSubscriber.attach_to :active_record
      DebugbarRb::ActionControllerLogSubscriber.attach_to :action_controller
      # DebugbarRb::ActionViewLogSubscriber.attach_to :action_view
    end

    initializer 'debugbar.track_models' do
      if defined? ActiveRecord::Base
        ActiveRecord::Base.after_initialize do |model|
          DebugbarRb::Acc.model(model.class.name)
        end
      end
    end
  end
end
