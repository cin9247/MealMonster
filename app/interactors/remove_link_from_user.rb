require_relative "./base"

module Interactor
  class RemoveLinkFromUser < Base
    register_boundary :user_gateway, -> { UserMapper.new }

    def run
      user = user_gateway.find request.user_id

      user.customer = nil
      user_gateway.update user

      OpenStruct.new object: user
    end
  end
end
