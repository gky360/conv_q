Rails.application.routes.draw do

  root to: 'conv_q#index'

  devise_for :users
  resources :users, param: :account, only: [:show] do
    resources :histories, only: [:index]
    resources :topics, only: [:index]
  end

  resources :topics
  post '/topics/:id' => 'topics#done_and_show', as: 'topic_with_done'

  resources :histories, only: [:create]
  # API
  namespace :api, { format: 'json' } do
    namespace :v1 do
      resources :tags, only: [:index]
    end
  end

end
