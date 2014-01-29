require_relative "./base"

module Interactor
  class UpdateCustomer < Base
    register_boundary :customer_gateway,  -> { CustomerMapper.new }
    register_boundary :catchment_area_gateway,  -> { CatchmentAreaMapper.new }

    def run
      ## TODO remove me and move me to request validation
      ca = nil
      if request.catchment_area_id
        ca = catchment_area_gateway.find request.catchment_area_id
      end

      customer = customer_gateway.find request.customer_id

      customer.forename       = request.forename
      customer.surname        = request.surname
      customer.prefix         = request.prefix
      customer.catchment_area = ca

      customer_gateway.update customer

      OpenStruct.new object: customer
    end
  end
end
