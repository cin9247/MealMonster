require "interactor_spec_helper"
require_relative "../../app/interactors/remove_link_from_user"

describe Interactor::RemoveLinkFromUser do
  let(:user_gateway) { dummy_gateway }
  let(:user) { OpenStruct.new }
  let(:user_id) { user_gateway.save user }
  let(:request) { OpenStruct.new user_id: user_id }
  let(:subject) { described_class.new(request) }

  before do
    subject.user_gateway = user_gateway

    subject.run
  end

  it "removes the link" do
    expect(user_gateway.fetch.first.customer).to eq nil
  end
end
