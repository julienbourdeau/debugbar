Debugbar::Engine.routes.draw do
  mount ActionCable.server => '/cable'

  get 'poll' => "polling#poll"
  options 'poll/confirm' => "polling#confirm"
  post 'poll/confirm' => "polling#confirm"

  get 'assets/script' => "assets#js"
end
