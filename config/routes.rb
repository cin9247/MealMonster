CareEAR::Application.routes.draw do
  root to: "main#show"

  resource :admins
  resources :customers do
    resources :invoices
  end
  resources :price_classes
  resources :catchment_areas
  resources :meals
  resources :offerings do
    get :new_import, on: :collection
    post :import, on: :collection
  end
  resources :tours do
    get :manage, on: :collection
  end
  put "tours", to: "tours#update"
  resources :orders
  resource :sessions
  resources :tickets
  resources :users do
    get :link, on: :member
    post :save_link, on: :member
    put :remove_link, on: :member
  end

  get "login", to: "sessions#new"
  get "register", to: "users#new"

  namespace :api do
    namespace :v1 do
      get "me", to: "me#show"
      resources :tickets

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
