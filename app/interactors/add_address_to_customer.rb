require_relative "./base"

module Interactor
  class AddAddressToCustomer < Base
    register_boundary :address_source, -> { Address.public_method(:new) }
    register_boundary :customer_gateway, -> { CustomerMapper.new }

    def initialize(request)
      @request = request
    end

    def run
      customer = customer_gateway.find @request.customer_id
      customer.address = address_source.call(street_name: @request.street_name,
                                             street_number: @request.street_number,
                                             postal_code: @request.postal_code,
                                             town: @request.town)

      customer_gateway.update customer
      OpenStruct.new object: customer.address
    end
  end
end
