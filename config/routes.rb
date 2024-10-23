Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
  get "/" => "home#top"
  get "top" => "home#home"

  get "login" => "users#login_form"
  post "login" => "users#login"
  get "signup" => "users#new"
  post "users/create" => "users#create"
  get "users/:id" => "users#user_info"
  get "users/:id/edit" => "users#edit"
  get "users/:id/authenticate" => "users#authenticate_form"
  post "users/:id/authenticate" => "users#authenticate" 
  post "users/:id/update" => "users#update"
  delete "logout" => "users#destory"

  resources :users do
    get 'authenticate_form', on: :member, as: :authenticate_form
  end
  

end
