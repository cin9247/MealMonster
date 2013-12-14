require_relative "./base"

module Interactor
  class UpdateCustomer < Base
    register_boundary :customer_gateway,  -> { CustomerMapper.new }

    def initialize(customer_id, forename, surname)
      @customer_id = customer_id
      @forename    = forename
      @surname     = surname
    end

    def run
      customer = customer_gateway.find @customer_id

      customer.forename = @forename
      customer.surname  = @surname

      customer_gateway.update customer

      OpenStruct.new object: customer
    end
  end
end
