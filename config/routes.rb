CareEAR::Application.routes.draw do
  root to: "main#show"

  resources :customers
  resources :meals
  resources :offerings
  resources :tours
  resources :orders
  resource :sessions
  resources :users

  get "login", to: "sessions#new"
  get "register", to: "users#new"

  namespace :api do
    namespace :v1 do
      resources :offerings
      resources :orders do
        put :deliver, on: :member
        put :load, on: :member
      end
      resources :tours do
        resources :keys
      end
    end
  end
end
