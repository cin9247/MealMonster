require_relative "./base"

module Interactor
  class Deliver < Base
    register_boundary :order_gateway, -> { OrderMapper.new }

    def run
      order = order_gateway.find request.order_id
      order.deliver!

      order_gateway.update order

      OpenStruct.new object: order
    end
  end
end
