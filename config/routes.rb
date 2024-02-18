Debugbar::Engine.routes.draw do
  mount ActionCable.server => '/cable'

  # TODO: Silence logs for this route if `::Rails.application.config.assets.quiet` is true
  get 'assets/script' => "assets#js"
end
