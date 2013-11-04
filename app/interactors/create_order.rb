module Interactor
  class CreateOrder
    attr_writer :order_gateway, :customer_gateway, :offering_gateway

    def initialize(customer_id, offering_id)
      @customer_id = customer_id
      @offering_id = offering_id
    end

    def run(actor_id)
      offering = offering_gateway.find(@offering_id)
      customer = customer_gateway.find(@customer_id)
      order = OpenStruct.new customer: customer, offering: offering, valid?: true

      if order.valid?
        order_gateway.save order
        OpenStruct.new status: :successfully_created
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
  end
end
