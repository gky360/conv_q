Rails.application.routes.draw do

  root to: 'conv_q#index'

  devise_for :users
  resources :users, param: :account, only: [:show] do
    resources :histories, only: [:index]
    resources :topics, only: [:index]
    resources :reports, param: :report_id, only: [:index]
  end

  resources :topics do
    resources :reports, param: :report_id, only: [:index, :new, :create]
  end
  post 'topics/:id' => 'topics#done_and_show', as: 'topic_with_done'

  resources :reports, param: :report_id, only: [:index, :show, :edit, :update, :destroy]

  # API
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      root to: 'root#index'

      mount_devise_token_auth_for 'User', at: 'auth'
      resources :users, param: :account, only: [:show]

      resources :tags, only: [:index]

      resources :topics, only: [:index]
      get 'topics/rand_for_user' => 'topics#rand_for_user'

      get  '*path', to: 'api#no_route_match'
    end
  end

  # conv_q_sp デバッグ用
  if Rails.env.development?
    get 'www/*path(.:format)' => 'conv_q#sp'
  end

end
