require "interactor_spec_helper"
require_relative "../../app/interactors/add_key_to_address"

describe Interactor::AddKeyToAddress do
  let(:address_gateway) { dummy_gateway }
  let(:address) {
    Class.new(OpenStruct) do
      def add_key(key)
        self.keys ||= []
        self.keys << key
      end
    end.new
  }

  before do
    subject.address_gateway = address_gateway
    subject.key_source = ->(args) { OpenStruct.new(args) }
  end

  let(:address_id) { address_gateway.save address }

  let(:request) { OpenStruct.new(address_id: address_id, name: "Schlüssel 1") }
  let(:subject) { Interactor::AddKeyToAddress.new(request) }

  it "adds the new key to the address" do
    subject.run

    address = address_gateway.find address_id
    expect(address.keys.size).to eq 1
    expect(address.keys.first.name).to eq "Schlüssel 1"
  end

  it "keeps the old key" do
    subject.run

    address.add_key double(:key)

    address = address_gateway.find address_id
    expect(address.keys.size).to eq 2
    expect(address.keys.first.name).to eq "Schlüssel 1"
  end
end
