CareEAR::Application.routes.draw do
  root to: "main#show"

  resources :customers
  resources :meals
  resources :offerings
  resources :tours
  resources :orders

  namespace :api do
    namespace :v1 do
      resources :offerings
      resources :orders
      resources :tours do
        resources :keys
      end
    end
  end
end
