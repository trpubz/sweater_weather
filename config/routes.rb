Rails.application.routes.draw do
  resources :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", :as => :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  post "/api/v0/users" => "api/v0/users#create"
  post "/api/v0/sessions" => "api/v0/sessions#create"
  get "/api/v0/forecast" => "api/v0/forecast#search"
  get "/api/v1/munchies" => "api/v1/munchies#search"

  post "/api/v0/road_trip" => "api/v0/road_trip#create"
end
