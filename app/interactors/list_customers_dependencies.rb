require_relative "./base"

module Interactor
  class ListCustomersDependencies < Base
    register_boundary :customer_gateway, -> { CustomerMapper.new }
    register_boundary :tour_gateway, -> { TourMapper.new }

    class Dependencies < Struct.new(:customer_name, :customer_id, :tour_list)

    end

    def run
      customer = customer_gateway.find request.customer_id
      tour_list = tour_gateway.fetch_sparse_with_customer_id(customer.id)

      OpenStruct.new object: Dependencies.new(customer.full_name, customer.id, tour_list)
    end
  end
end
