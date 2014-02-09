require_relative "./base"
require_relative "../models/key"

module Interactor
  class AddKeyToAddress < Base
    register_boundary :address_gateway, -> { AddressMapper.new }

    def run
      address = address_gateway.find request.address_id
      key = Key.new name: request.name

      address.add_key key

      address_gateway.update address
    end
  end
end
