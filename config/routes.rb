MealsOnWheels::Application.routes.draw do
  root to: "main#show"

  resources :meals
  resources :menus
  resources :tours
end
