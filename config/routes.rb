Rails.application.routes.draw do

  root to: 'conv_q#index'

  devise_for :users
  get '/users/:account' => 'users#show', as: 'user'
  get '/users/:account/histories' => 'users#histories', as: 'user_histories'
  get '/users/:account/topics' => 'users#topics', as: 'user_topics'

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
