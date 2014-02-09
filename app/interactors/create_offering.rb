require_relative "./base"
require_relative "../models/offering"

module Interactor
  class CreateOffering < Base
    register_boundary :offering_gateway, -> { OfferingMapper.new }
    register_boundary :meal_gateway, -> { MealMapper.new }
    register_boundary :price_class_gateway, -> { PriceClassMapper.new }

    def run
      meals = request.meal_ids.map { |id| meal_gateway.find(id) }
      price_class = price_class_gateway.find request.price_class_id
      offering = Offering.new(date: request.date, menu: OpenStruct.new(meals: meals, name: request.name), price_class: price_class)

      if offering.valid?
        offering_gateway.save offering
        OpenStruct.new object: offering
      else
        OpenStruct.new status: :invalid_request
      end
    end
  end
end
