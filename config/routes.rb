Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :artists, only: [:index, :show]
  resources :albums do
    member do
      get 'sidebar_info'
    end
    resources :reviews, only: [:create, :destroy]
  end
  resources :tracks, only: [:show] do
    resources :comments, only: [:create, :destroy]
  end
  resources :playlists do
    member do
      post :add_track
      delete :remove_track
    end
  end
  resources :favorites, only: [:create, :destroy]
  resources :purchases, only: [:index]
  resources :notifications, only: [:index, :update]
  resources :tracks do
    resources :comments, only: [:create, :destroy]
  end
  
  resources :albums do
    resources :comments, only: [:create, :destroy]
  end
    
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  root 'pages#home'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  # root "articles#index"
  post 'filter_albums', to: 'pages#filter_albums'
end
