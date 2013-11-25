require "interactor_spec_helper"
require_relative "../../app/interactors/create_user"

describe Interactor::CreateUser do
  let(:name) { "hans" }
  let(:password) { "secret123" }
  let(:user_gateway) { dummy_gateway }
  let(:user_source) { ->(args) { OpenStruct.new(args) } }

  subject { Interactor::CreateUser.new(name, password) }

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
