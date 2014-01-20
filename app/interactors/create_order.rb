require_relative "./base"

module Interactor
  class CreateOrder < Base
    register_boundary :order_gateway,    -> { OrderMapper.new }
    register_boundary :customer_gateway, -> { CustomerMapper.new }
    register_boundary :offering_gateway, -> { OfferingMapper.new }
    register_boundary :order_source,     -> { Order.public_method(:new) }

    def run
      offering = offering_gateway.find(request.offering_id)
      customer = customer_gateway.find(request.customer_id)
      order = order_source.call customer: customer, offering: offering, note: request.note

      if order.valid?
        order_gateway.save order
        OpenStruct.new status: :successfully_created, object: order
      else
        OpenStruct.new status: :invalid_request
      end
    end
  end
end
