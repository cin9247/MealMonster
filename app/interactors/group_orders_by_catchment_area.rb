require_relative "./base"

module Interactor
  class GroupOrdersByCatchmentArea < Base
    register_boundary :order_gateway, -> { OrderMapper.new }

    def run
      orders = order_gateway.find_by_date request.date
      # TODO: Add mapper function which returns all offerings which have been ordered.
      orders = orders.map do |o|
        o.offerings.map do |of|
          OpenStruct.new(name: of.name, catchment_area_name: o.customer.catchment_area.try(:name))
        end
      end.flatten

      result = orders.group_by { |o| o.catchment_area_name }
      result = result.map do |name, orders|
        OpenStruct.new name: name, orders: orders.group_by { |o| o.name }
      end

      OpenStruct.new object: result
    end
  end
end
