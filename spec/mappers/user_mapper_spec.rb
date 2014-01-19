require "spec_helper"

describe UserMapper do
  describe "loading of associated customer" do
    it "loads the customer" do
    end
  end

  describe "loading of role" do
    let(:user) { User.new(name: "Peter", password: "password") }

    before do
      user.add_role "admin"
      user.add_role "driver"

      subject.save user
    end

    let(:roles) { subject.fetch.first.roles }

    it "loads the associated roles" do
      expect(roles.size).to eq 2
      expect(roles).to include "admin"
      expect(roles).to include "driver"
    end
  end
end
