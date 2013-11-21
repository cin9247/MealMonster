require_relative "./base"

module Interactor
  class AddKeyToAddress < Base
    register_boundary :address_gateway, -> { AddressMapper.new }
    register_boundary :key_source, -> { Key.public_method(:new) }

    def initialize(address_id, name)
      @address_id = address_id
      @name = name
    end

    def run
      address = address_gateway.find @address_id
      key = key_source.call name: @name

      address.add_key key

      address_gateway.update address
    end
  end
end
