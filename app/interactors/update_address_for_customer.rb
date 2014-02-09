require_relative "./base"
require_relative "../models/address"

module Interactor
  class UpdateAddressForCustomer < Base
    register_boundary :customer_gateway, -> { CustomerMapper.new }

    def run
      customer = customer_gateway.find request.customer_id

      customer.address ||= Address.new

      customer.address.street_name = request.street_name
      customer.address.street_number = request.street_number
      customer.address.postal_code = request.postal_code
      customer.address.town = request.town

      customer_gateway.update customer
    end
  end
end
