require "interactor_spec_helper"
require_relative "../../app/interactors/add_role"
require_relative "../../app/models/user"

describe Interactor::AddRole do
  let(:user_gateway) { dummy_gateway }
  let(:user) { User.new }
  let(:user_id) { user_gateway.save user }
  let(:role) { "driver" }
  let(:request) { OpenStruct.new(user_id: user_id, role: role) }

  subject { Interactor::AddRole.new(request) }

  before do
    subject.user_gateway = user_gateway
  end

  it "adds the role to the user" do
    subject.run
    user = user_gateway.find user_id
    expect(user.roles).to include "driver"
  end
end
