require_relative "./base"

module Interactor
  class CreateMeal < Base
    register_boundary :meal_gateway, -> { MealMapper.new }
    register_boundary :meal_source,  -> { Meal.public_method(:new) }

    def initialize(name, kilojoules, bread_units)
      @name        = name
      @kilojoules  = kilojoules
      @bread_units = bread_units
    end

    def run
      meal = meal_source.call name: @name, kilojoules: @kilojoules, bread_units: @bread_units
      if meal.valid?
        meal_gateway.save meal
        OpenStruct.new status: :successfully_created, object: meal
      else
        OpenStruct.new status: :invalid_request, object: meal
      end
    end
  end
end
