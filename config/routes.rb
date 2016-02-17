Rails.application.routes.draw do

  get 'users/show'

  devise_for :users
  root to: 'conv_q#index'

  resources :topics, only: [:index, :show]
  post '/topics/:id' => 'topics#done_and_show', as: 'topic_with_done'

  resources :histories, only: [:create]

  get '/users/:account' => 'users#show', as: 'user'

  # API
  namespace :api, { format: 'json' } do
    namespace :v1 do
      resources :tags, only: [:index]
    end
  end

end
