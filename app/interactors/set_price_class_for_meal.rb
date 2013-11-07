module Interactor
  class SetPriceClassForMeal
    attr_writer :meal_gateway, :price_class_gateway

    def initialize(meal_id, price_class_id)
      @meal_id        = meal_id
      @price_class_id = price_class_id
    end

    def run
      meal = meal_gateway.find @meal_id
      pc   = price_class_gateway.find @price_class_id
      meal.price_class = pc
      meal_gateway.update meal
    end

    private
      def meal_gateway
        @meal_gateway ||= MealMapper.new
      end

      def price_class_gateway
        @price_class_gateway ||= PriceClassMapper.new
      end
  end
end
