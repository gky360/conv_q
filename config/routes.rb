Rails.application.routes.draw do

  devise_for :users
  root to: 'conv_q#index'

  resources :topics, only: [:index, :show]

end
