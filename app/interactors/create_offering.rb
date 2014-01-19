require_relative "./base"

module Interactor
  class CreateOffering < Base
    register_boundary :offering_gateway, -> { OfferingMapper.new }
    register_boundary :meal_gateway, -> { MealMapper.new }
    register_boundary :price_class_gateway, -> { PriceClassMapper.new }
    register_boundary :offering_source, -> { Offering.public_method(:new) }

    def initialize(name, date, meal_ids, price_class_id)
      @name = name
      @date = date
      @meal_ids = meal_ids
      @price_class_id = price_class_id
    end

    def run
      meals = @meal_ids.map { |id| meal_gateway.find(id) }
      price_class = price_class_gateway.find @price_class_id
      offering = offering_source.call(date: @date, menu: OpenStruct.new(meals: meals, name: @name), price_class: price_class)

      if offering.valid?
        offering_gateway.save offering
        OpenStruct.new object: offering
      else
        OpenStruct.new status: :invalid_request
      end
    end
  end
end
