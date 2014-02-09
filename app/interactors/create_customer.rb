require_relative "./base"
require_relative "../models/customer"

module Interactor
  class CreateCustomer < Base
    register_boundary :customer_gateway, -> { CustomerMapper.new }

    def run
      customer = Customer.new forename: request.forename, surname: request.surname, prefix: request.prefix, telephone_number: request.telephone_number

      if customer.valid?
        customer_gateway.save customer
        OpenStruct.new status: :successfully_created, success?: true, object: customer
      else
        OpenStruct.new status: :invalid_request
      end
    end
  end
end
