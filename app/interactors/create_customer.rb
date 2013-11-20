require_relative './base'

module Interactor
  class CreateCustomer < Base
    register_boundary :customer_gateway, -> { CustomerMapper.new }
    register_boundary :customer_source,  -> { Customer.public_method(:new) }

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
  end
end
