require "interactor_spec_helper"
require_relative "../../app/interactors/register_user"

describe Interactor::RegisterUser do
  let(:name) { "hans" }
  let(:password) { "secret123" }
  let(:user_gateway) { dummy_gateway }
  let(:user_source) { ->(args) { OpenStruct.new(args) } }

  let(:request) { OpenStruct.new(name: name, password: password) }
  subject { Interactor::RegisterUser.new(request) }

  before do
    subject.user_gateway = user_gateway
    subject.user_source = user_source
  end

  it "creates a new user" do
    subject.run

    expect(user_gateway.fetch.size).to eq 1
    expect(user_gateway.fetch.first.name).to eq "hans"
  end
end
