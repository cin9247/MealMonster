require_relative "../../app/models/address"
require "ostruct"

describe Address do
  describe "#keys" do
    it "defaults to an empty array" do
      expect(subject.keys).to eq []
    end

    it "can be set" do
      subject.keys = [1, 2]
      expect(subject.keys).to eq [1, 2]
    end
  end

  describe "#add_key" do
    let(:key) { OpenStruct.new }
    before { subject.add_key key }

    it "adds the key" do
      expect(subject.keys).to eq [key]
    end

    it "sets the link back to the address" do
      expect(key.address).to eq subject
    end
  end
end
