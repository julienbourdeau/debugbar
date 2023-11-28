DebugbarRb::Engine.routes.draw do
  mount ActionCable.server => '/cable'
  get 'assets/style' => "assets#css", format: :css
  get 'assets/script' => "assets#js"
end
