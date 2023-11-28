DebugbarRb::Engine.routes.draw do
  mount ActionCable.server => '/cable'

  # TODO: Silence logs for these routes if `::Rails.application.config.assets.quiet` is true
  get 'assets/style' => "assets#css", format: :css
  get 'assets/script' => "assets#js"
end
