require_relative "./base"
require_relative "../models/order"

module Interactor
  class CreateOrder < Base
    register_boundary :order_gateway,    -> { OrderMapper.new }
    register_boundary :customer_gateway, -> { CustomerMapper.new }
    register_boundary :offering_gateway, -> { OfferingMapper.new }

    def run
      offerings = offering_gateway.find(request.offering_ids)
      customer = customer_gateway.find(request.customer_id)
      order = Order.new customer: customer, offerings: offerings, note: request.note, date: offerings.first.date

      if order.valid?
        order_gateway.save order
        OpenStruct.new status: :successfully_created, object: order
      else
        OpenStruct.new status: :invalid_request
      end
    end
  end
end
