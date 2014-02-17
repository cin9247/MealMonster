require_relative "./base"

module Interactor
  class UpdateCustomer < Base
    register_boundary :customer_gateway,  -> { CustomerMapper.new }

    def run
      customer = customer_gateway.find request.customer_id

      customer.forename         = request.forename
      customer.surname          = request.surname
      customer.prefix           = request.prefix
      customer.telephone_number = request.telephone_number
      customer.note             = request.note
      customer.date_of_birth    = request.date_of_birth

      customer_gateway.update customer

      OpenStruct.new object: customer
    end
  end
end
