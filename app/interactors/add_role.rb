require_relative "./base"

module Interactor
  class AddRole < Base
    register_boundary :user_gateway, -> { UserMapper.new }

    def run
      user = user_gateway.find request.user_id
      user.add_role request.role
      user_gateway.update user
    end
  end
end
