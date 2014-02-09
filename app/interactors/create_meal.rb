require_relative "./base"
require_relative "../models/meal"

module Interactor
  class CreateMeal < Base
    register_boundary :meal_gateway, -> { MealMapper.new }

    def run
      meal = Meal.new name: request.name, kilojoules: request.kilojoules, bread_units: request.bread_units
      if meal.valid?
        meal_gateway.save meal
        OpenStruct.new status: :successfully_created, object: meal
      else
        OpenStruct.new status: :invalid_request, object: meal
      end
    end
  end
end
