require_relative "./base"

module Interactor
  class UpdateAddressForCustomer < Base
    register_boundary :customer_gateway, -> { CustomerMapper.new }
    register_boundary :address_source,  -> { Address.public_method(:new) }

    def initialize(customer_id, street_name, street_number, postal_code, town)
      @customer_id = customer_id
      @street_name = street_name
      @street_number = street_number
      @postal_code = postal_code
      @town = town
    end

    def run
      customer = customer_gateway.find @customer_id

      customer.address ||= address_source.call

      customer.address.street_name = @street_name
      customer.address.street_number = @street_number
      customer.address.postal_code = @postal_code
      customer.address.town = @town

      customer_gateway.update customer
    end
  end
end
