require "interactor_spec_helper"
require_relative "../../app/interactors/create_all_time_offering"

describe Interactor::CreateAllTimeOffering do
  let(:offering_gateway) { dummy_gateway }
  let(:price_class_gateway) { dummy_gateway }
  subject { Interactor::CreateAllTimeOffering.new(request) }
  let(:request) { OpenStruct.new(name: "Abendessen", price_class_id: 23) }

  before do
    subject.offering_gateway = offering_gateway
    subject.price_class_gateway = price_class_gateway

    price_class_gateway.save OpenStruct.new(id: 23)
  end

  it "saves the offering" do
    subject.run
    expect(offering_gateway.fetch.size).to eq 1
    expect(offering_gateway.fetch.first.menu.name).to eq "Abendessen"
  end
end
