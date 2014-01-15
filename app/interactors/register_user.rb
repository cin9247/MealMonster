require_relative "./base"

module Interactor
  class RegisterUser < Base
    register_boundary :user_gateway, -> { UserMapper.new }
    register_boundary :user_source, -> { User.public_method(:new) }

    def run
      user = user_source.call name: request.name, password: request.password

      user_gateway.save user

      OpenStruct.new object: user
    end
  end
end
