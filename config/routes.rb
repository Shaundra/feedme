Rails.application.routes.draw do
  resources :tags
  resources :feed_categories
  resources :feeds, only: [:index, :new, :create, :show, :update] do
    member do
      # recognizes get `/feeds/:id/settings` and routes to feeds#settings, w feed.id passed in params[:id] & settings_feed_path helper created
      get 'settings'
      patch 'settings', to: 'feeds#update_settings'
    end
    resources :entries, only: [:show]
    get '/entries', to: 'entries#refresh'
  end
  resources :entries, only: [:index] do
    member do
      get 'settings'
      patch 'settings', to: 'entries#update_settings'
    end
  end
  resources :users
  resources :feed_subscriptions

  get '/feeds/:id/refresh', to: 'feeds#refresh', as: 'refresh_feed'

  #Session Routes
  root 'application#home'
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  post '/logout' => 'sessions#destroy'

  get '/analytics', to: 'analytics#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
