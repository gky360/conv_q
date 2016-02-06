Rails.application.routes.draw do

  get 'users/show'

  devise_for :users
  root to: 'conv_q#index'

  resources :topics, only: [:index, :show]

  get '/users/:account' => 'users#show', as: 'user'

end
