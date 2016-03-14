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
  post '/topics/:id' => 'topics#done_and_show', as: 'topic_with_done'

  resources :histories, only: [:create]

  resources :reports, param: :report_id, only: [:index, :show, :edit, :update, :destroy]

  # API
  namespace :api, { format: 'json' } do
    namespace :v1 do
      resources :tags, only: [:index]
    end
  end

end
