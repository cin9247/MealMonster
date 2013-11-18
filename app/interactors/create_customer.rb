require_relative './base'

module Interactor
  class CreateCustomer < Base
    attr_writer :customer_gateway, :customer_source

    def initialize(forename, surname)
      @forename = forename
      @surname = surname
    end

    def run
      customer = customer_source.call forename: @forename, surname: @surname
      if customer.valid?
        customer_gateway.save customer
        OpenStruct.new status: :successfully_created, success?: true, object: customer
      else
        OpenStruct.new status: :invalid_request
      end
    end

    private
      def customer_gateway
        @customer_gateway ||= CustomerMapper.new
      end

      def customer_source
        @customer_source ||= Customer.public_method(:new)
      end
  end
end
