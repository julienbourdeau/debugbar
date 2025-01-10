Debugbar::Engine.routes.draw do
  if defined? ActionCable
    mount ActionCable.server => '/cable'
  end

  get 'get/:id' => "polling#get"

  get 'poll' => "polling#poll"
  options 'poll/confirm' => "polling#confirm"
  post 'poll/confirm' => "polling#confirm"

  get 'assets/script' => "assets#js"
end
