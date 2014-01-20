require_relative "./base"

module Interactor
  class AddKeyToAddress < Base
    register_boundary :address_gateway, -> { AddressMapper.new }
    register_boundary :key_source, -> { Key.public_method(:new) }

    def run
      address = address_gateway.find request.address_id
      key = key_source.call name: request.name

      address.add_key key

      address_gateway.update address
    end
  end
end
