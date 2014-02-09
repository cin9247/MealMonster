require_relative "./base"
require_relative "../models/address"

module Interactor
  class AddAddressToCustomer < Base
    register_boundary :customer_gateway, -> { CustomerMapper.new }

    def run
      customer = customer_gateway.find @request.customer_id
      customer.address = Address.new(street_name: @request.street_name,
                                     street_number: @request.street_number,
                                     postal_code: @request.postal_code,
                                     town: @request.town)

      customer_gateway.update customer
      OpenStruct.new object: customer.address
    end
  end
end
