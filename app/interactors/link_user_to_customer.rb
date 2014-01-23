require_relative "./base"

module Interactor
  class LinkUserToCustomer < Base
    register_boundary :user_gateway, -> { UserMapper.new }
    register_boundary :customer_gateway, -> { CustomerMapper.new }

    def run
      user = user_gateway.find request.user_id
      customer = customer_gateway.find request.customer_id

      user.customer = customer
      user_gateway.update user

      OpenStruct.new object: user
    end
  end
end
