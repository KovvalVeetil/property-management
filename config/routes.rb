Rails.application.routes.draw do
  devise_for :users

  get "up" => "rails/health#show", as: :rails_health_check

  resources :users
  resources :properties
  resources :bookings
  resources :payments
end
