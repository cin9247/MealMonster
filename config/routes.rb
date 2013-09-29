MealsOnWheels::Application.routes.draw do
  root to: "main#show"

  resources :meals
  resources :menus
end
