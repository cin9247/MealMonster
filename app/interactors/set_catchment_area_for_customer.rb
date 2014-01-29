require_relative "./base"

module Interactor
  class SetCatchmentAreaForCustomer < Base
    register_boundary :customer_gateway, -> { CustomerMapper.new }
    register_boundary :catchment_area_gateway, -> { CatchmentAreaMapper.new }

    def run
      customer       = customer_gateway.find @request.customer_id
      catchment_area = catchment_area_gateway.find @request.catchment_area_id

      customer.catchment_area = catchment_area
      customer_gateway.update customer

      OpenStruct.new object: customer.address
    end
  end
end
