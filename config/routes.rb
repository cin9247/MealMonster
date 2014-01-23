CareEAR::Application.routes.draw do
  root to: "main#show"

  resources :customers do
    resources :invoices
  end
  resources :meals
  resources :offerings
  resources :tours do
    get :manage, on: :collection
  end
  put "tours", to: "tours#update"
  resources :orders
  resource :sessions
  resources :users do
    get :link, on: :member
    post :save_link, on: :member
    put :remove_link, on: :member
  end

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
