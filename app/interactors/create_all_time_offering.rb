require_relative "base"
require_relative "../models/all_time_offering.rb"

module Interactor
  class CreateAllTimeOffering < Base
    register_boundary :offering_gateway, -> { OfferingMapper.new }
    register_boundary :price_class_gateway, -> { PriceClassMapper.new }

    def run
      price_class = price_class_gateway.find request.price_class_id
      menu = OpenStruct.new(name: request.name, meals: [])
      all_time_offering = AllTimeOffering.new(price_class: price_class, menu: menu)
      offering_gateway.save all_time_offering
      OpenStruct.new(object: all_time_offering)
    end
  end
end
