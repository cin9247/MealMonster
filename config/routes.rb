CareEAR::Application.routes.draw do
  root to: "main#show"

  resource :admins
  resources :customers do
    get :import_form, on: :collection
    post :import, on: :collection
    resources :invoices
  end
  resources :price_classes
  resources :catchment_areas
  resources :meals
  resources :offerings do
    get :other, on: :collection
    get :new_other, on: :collection
    get :new_import, on: :collection
    post :import, on: :collection
  end
  post :all_time_offerings, to: "offerings#create_other"
  resources :tours do
    get :manage, on: :member
    get :manage, on: :collection
  end
  put "tours", to: "tours#update"
  resources :orders
  resource :sessions
  resources :tickets do
    post :close, on: :member
    post :reopen, on: :member
  end
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
        post :note, on: :member
      end
      resources :tours do
        resources :keys
      end
    end
  end
end
