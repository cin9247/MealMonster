require "spec_helper"

describe AddressMapper do
  let(:address) { Address.new town: "Karlsruhe", postal_code: "76131" }
  let(:keys) { [Key.new(name: "Key 1"), Key.new(name: "Key 2")] }

  before do
    address.keys = keys
  end

  describe "#save" do
    it "saves the address" do
      subject.save address
      expect(subject.fetch.size).to eq 1
      expect(subject.fetch.first.town).to eq "Karlsruhe"
      expect(subject.fetch.first.postal_code).to eq "76131"
    end

    it "saves the associated keys" do
      subject.save address

      expect(subject.fetch.first.keys.size).to eq 2
    end

    it "only saves the key if they haven't been saved yet" do
      subject.save address

      new_address = Address.new keys: address.keys, postal_code: address.postal_code, town: address.town

      subject.save new_address

      expect(DB[:keys].count).to eq 2
    end
  end

  describe "#update" do
    before do
      subject.save address
    end

    it "saves the address" do
      address.town = "Stuttgart"
      subject.update address
      loaded_address = subject.find address.id

      expect(loaded_address.town).to eq "Stuttgart"
      expect(loaded_address.postal_code).to eq "76131"
    end

    it "saves the associated keys" do
      address.add_key Key.new(name: "Neuer Schlüssel")

      subject.update address

      loaded_address = subject.find address.id

      expect(loaded_address.keys.size).to eq 3
      expect(DB[:keys].count).to eq 3
    end
  end
end
