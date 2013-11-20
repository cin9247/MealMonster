require_relative "./base"

module Interactor
  class AddAddressToCustomer < Base
    register_boundary :address_source, -> { Address.public_method(:new) }
    register_boundary :customer_gateway, -> { CustomerMapper.new }

    def initialize(customer_id, street_name, street_number, postal_code, town)
      @customer_id = customer_id
      @street_name = street_name
      @street_number = street_number
      @postal_code = postal_code
      @town = town
    end

    def run
      customer = customer_gateway.find @customer_id
      customer.address = address_source.call(street_name: @street_name,
                                             street_number: @street_number,
                                             postal_code: @postal_code,
                                             town: @town)

      customer_gateway.update customer
    end
  end
end
