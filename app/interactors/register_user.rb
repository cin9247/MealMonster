require_relative "./base"
require_relative "../models/user"

module Interactor
  class RegisterUser < Base
    register_boundary :user_gateway, -> { UserMapper.new }

    def run
      user = User.new name: request.name, password: request.password

      user_gateway.save user

      OpenStruct.new object: user
    end
  end
end
