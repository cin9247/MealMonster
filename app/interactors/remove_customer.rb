module Interactor
  class RemoveCustomer < Base
    register_boundary :customer_gateway, -> { CustomerMapper.new }

    def run
      customer = customer_gateway.find request.customer_id
      customer_gateway.delete customer
    end
  end
end
