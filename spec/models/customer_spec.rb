require_relative "../../app/models/customer"

describe Customer do
  describe "#subscribe!" do
    let(:organization) { double(:organization) }

    it "adds itself to the organization" do
      subject.organization = organization
      organization.should_receive(:add_customer).with(subject)
      subject.subscribe!
    end
  end

  describe "#full_name" do
    subject { Customer.new forename: "Max", surname: "Mustermann" }

    it "returns first and last name" do
      expect(subject.full_name).to eq "Max Mustermann"
    end
  end
end
