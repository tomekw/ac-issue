Rails.application.routes.draw do
  mount ActionCable.server => "/ws"
end
