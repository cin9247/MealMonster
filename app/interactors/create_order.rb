require_relative "./base"

module Interactor
  class CreateOrder < Base
    attr_writer :order_gateway, :customer_gateway, :offering_gateway
    attr_writer :order_source

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

    private
      def order_gateway
        @order_gateway ||= OrderMapper.new
      end

      def offering_gateway
        @offering_gateway ||= OfferingMapper.new
      end

      def customer_gateway
        @customer_gateway ||= CustomerMapper.new
      end

      def order_source
        @order_source ||= Order.public_method(:new)
      end
  end
end
