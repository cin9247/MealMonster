require_relative "./base"

module Interactor
  class CreateCustomer < Base
    register_boundary :customer_gateway, -> { CustomerMapper.new }
    register_boundary :catchment_area_gateway, -> { CatchmentAreaMapper.new }
    register_boundary :customer_source,  -> { Customer.public_method(:new) }

    def run
      ## TODO remove me and move me to request validation
      ca = nil
      if request.catchment_area_id
        ca = catchment_area_gateway.find request.catchment_area_id
      end
      customer = customer_source.call forename: request.forename, surname: request.surname, prefix: request.prefix, catchment_area: ca

      if customer.valid?
        customer_gateway.save customer
        OpenStruct.new status: :successfully_created, success?: true, object: customer
      else
        OpenStruct.new status: :invalid_request
      end
    end
  end
end
