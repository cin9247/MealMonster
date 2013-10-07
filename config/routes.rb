MealsOnWheels::Application.routes.draw do
  root to: "main#show"

  resources :customers
  resources :meals
  resources :menus
  resources :tours
end
