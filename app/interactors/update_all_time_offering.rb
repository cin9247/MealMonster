require_relative "base"
require_relative "../models/all_time_offering.rb"

module Interactor
  class UpdateAllTimeOffering < Base
    register_boundary :offering_gateway, -> { OfferingMapper.new }
    register_boundary :menu_gateway, -> { MenuMapper.new }
    register_boundary :price_class_gateway, -> { PriceClassMapper.new }

    def run
      offering = offering_gateway.find request.offering_id
      price_class = price_class_gateway.find request.price_class_id

      offering.menu.name = request.name
      offering.price_class = price_class
      offering_gateway.update offering
      menu_gateway.update offering.menu
      OpenStruct.new(object: offering)
    end
  end
end
