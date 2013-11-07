module Interactor
  class CreateMeal
    attr_writer :meal_gateway

    def initialize(meal)
      @meal = meal
    end

    def run
      if @meal.valid?
        meal_gateway.save @meal
        OpenStruct.new status: :successfully_created, success?: true
      else
        OpenStruct.new status: :invalid_request, success?: false
      end
    end

    private
      def meal_gateway
        @meal_gateway ||= MealMapper.new
      end
  end
end
