Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"

  namespace :api do
    namespace :v1 do
      resources :users do
        member do
          get :authenticate_form
          post :authenticate
        end
      end
  
      resources :regular_schedules
      resources :schedules do
        collection do
          get :show_by_date
        end
      end
  
      resources :shifts do
        collection do
          delete :destroy_month
        end
      end
    end
  end

  get "/" => "home#top"
  get "home" => "home#home"
  get "login" => "users#login_form"
  post "login" => "users#login"
  get "logout" => "users#logout"
  get "signup" => "users#new"
  get "schedules/:date", to: "schedule#show", as: :day
end
