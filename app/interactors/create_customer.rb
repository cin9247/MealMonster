require 'ostruct'

module Interactor
  class CreateCustomer
    attr_writer :customer_gateway

    def initialize(customer)
      @customer = customer
    end

    def run
      if @customer.valid?
        customer_gateway.save @customer
        OpenStruct.new status: :successfully_created, success?: true, id: @customer.id
      else
        OpenStruct.new status: :invalid_request
      end
    end

    private
      def customer_gateway
        @customer_gateway ||= CustomerMapper.new
      end
  end
end
