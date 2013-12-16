require_relative "./base"

module Interactor
  class AddRole < Base
    register_boundary :user_gateway, -> { UserMapper.new }

    def initialize(user_id, role)
      @user_id = user_id
      @role    = role
    end

    def run
      user = user_gateway.find @user_id
      user.add_role @role
      user_gateway.update user
    end
  end
end
