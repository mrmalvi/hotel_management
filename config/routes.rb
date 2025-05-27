Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Mount Active Storage routes
  mount ActiveStorage::Engine => '/rails/active_storage'

  # Root path
  root 'hotels#index'

  # Public routes
  resources :hotels, only: [:index, :show] do
    resources :rooms, only: [:index, :show]
  end
  resources :bookings, only: [:new, :create, :show]

  # Admin routes
  namespace :admin do
    root to: 'dashboard#index'
    resources :hotels do
      resources :rooms
    end
    resources :bookings
    resources :amenities
  end

  # Authentication routes
  devise_for :users
end
