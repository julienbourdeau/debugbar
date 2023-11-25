DebugbarRb::Engine.routes.draw do
  mount ActionCable.server => '/cable'
end
