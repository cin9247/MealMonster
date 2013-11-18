require_relative "./base"

module Interactor
  class CreateOffering < Base
    attr_writer :offering_gateway, :meal_gateway, :offering_source

    def initialize(date, meal_ids)
      @date = date
      @meal_ids = meal_ids
    end

    def run
      meals = @meal_ids.map { |id| meal_gateway.find(id) }
      offering = offering_source.call(date: @date, menu: OpenStruct.new(meals: meals))

      if offering.valid?
        offering_gateway.save offering
        OpenStruct.new object: offering
      else
        OpenStruct.new status: :invalid_request
      end
    end

    private
      def offering_gateway
        @offering_gateway ||= OfferingMapper.new
      end

      def meal_gateway
        @meal_gateway ||= MealMapper.new
      end

      def offering_source
        @offering_source ||= Offering.public_method(:new)
      end
  end
end
