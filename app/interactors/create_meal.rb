module Interactor
  class CreateMeal
    attr_writer :meal_gateway

    def initialize(meal)
      @meal = meal
    end

    def run
      if @meal.valid?
        meal_gateway.save @meal
        OpenStruct.new status: :successfully_created
      else
        OpenStruct.new status: :invalid_request
      end
    end

    private
      def meal_gateway
        @meal_gateway ||= MealMapper.new
      end
  end
end
