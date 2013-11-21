require_relative "./base"

module Interactor
  class CreateOrder < Base
    register_boundary :order_gateway,    -> { OrderMapper.new }
    register_boundary :customer_gateway, -> { CustomerMapper.new }
    register_boundary :offering_gateway, -> { OfferingMapper.new }
    register_boundary :order_source,     -> { Order.public_method(:new) }

    def initialize(customer_id, offering_id, note=nil)
      @customer_id = customer_id
      @offering_id = offering_id
      @note = note
    end

    def run(actor_id=nil)
      offering = offering_gateway.find(@offering_id)
      customer = customer_gateway.find(@customer_id)
      order = order_source.call customer: customer, offering: offering, note: @note

      if order.valid?
        order_gateway.save order
        OpenStruct.new status: :successfully_created, object: order
      else
        OpenStruct.new status: :invalid_request
      end
    end
  end
end
