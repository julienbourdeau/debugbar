# This middleware silences the Rails logger for requests to the Debugbar routes.
# The poll route can be *very* noisy.
# Rails already does this for the /assets route, see Sprockets::Rails::QuietAssets.
#
# @see Sprockets::Rails::QuietAssets
# @see Rails::Rack::Logger#silence
#
module Debugbar
  class QuietRoutes
    def initialize(app)
      @app = app
      @route_regex = %r(\A/{0,2}#{::Debugbar.config.prefix})
    end

    def call(env)
      if env['PATH_INFO'] =~ @route_regex
        ::Rails.logger.silence { @app.call(env) }
      else
        @app.call(env)
      end
    end
  end
end
