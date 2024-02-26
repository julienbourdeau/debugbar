Debugbar::Engine.routes.draw do
  mount ActionCable.server => '/cable'

  get 'poll' => "polling#poll"
  options 'poll/confirm' => "polling#confirm"
  post 'poll/confirm' => "polling#confirm"

  # TODO: Silence logs for this route if `::Rails.application.config.assets.quiet` is true
  get 'assets/script' => "assets#js"
end
