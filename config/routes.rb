MealsOnWheels::Application.routes.draw do
  root to: "main#show"

  resources :meals
end
