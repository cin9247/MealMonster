module Interactor
  class CreateMeal
    attr_writer :meal_gateway, :meal_source

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

    private
      def meal_gateway
        @meal_gateway ||= MealMapper.new
      end

      def meal_source
        @meal_source ||= Meal.public_method(:new)
      end
  end
end
