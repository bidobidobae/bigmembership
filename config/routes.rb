Rails.application.routes.draw do
  get  "sign_in", to: "sessions#new"
  post "sign_in", to: "sessions#create"
  get  "sign_up", to: "registrations#new"
  post "sign_up", to: "registrations#create"
  get 'registrations/profile/:id', to: "registrations#profile", as: "profile" 
  get 'users', to: "registrations#index", as: "users"
  get "users/:id/edit", to: "registrations#edit", as: "edit_user"
  patch "users/:id", to: "registrations#update", as: "user_update"

  resources :reports
  resources :sessions, only: [:index, :show, :destroy]
  resource  :password, only: [:edit, :update]
  namespace :identity do
    resource :email,              only: [:edit, :update]
    resource :email_verification, only: [:show, :create]
    resource :password_reset,     only: [:new, :edit, :create, :update]
  end
  namespace :two_factor_authentication do
    namespace :challenge do
      resource :totp,           only: [:new, :create]
      resource :recovery_codes, only: [:new, :create]
    end
    namespace :profile do
      resource  :totp,           only: [:new, :create, :update]
      resources :recovery_codes, only: [:index, :create]
    end
  end
  get  "/auth/failure",            to: "sessions/omniauth#failure"
  get  "/auth/:provider/callback", to: "sessions/omniauth#create"
  post "/auth/:provider/callback", to: "sessions/omniauth#create"
  namespace :sessions do
    resource :sudo, only: [:new, :create]
  end

  get "home/index", to: "home#index", as: "admin"
  root "passthrough#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
