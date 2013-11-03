require_relative "../../app/models/customer"

describe Customer do
  describe "#full_name" do
    subject { Customer.new forename: "Max", surname: "Mustermann" }

    it "returns first and last name" do
      expect(subject.full_name).to eq "Max Mustermann"
    end
  end
end
