require "spec_helper"

describe UserMapper do
  let(:user) { User.new(name: "Peter", password: "password") }

  describe "loading of associated customer" do
    before do
      customer = Customer.new(forename: "Peter", surname: "Mustermann")
      CustomerMapper.new.save customer
      user.customer = customer
      subject.save user
    end

    it "loads the customer" do
      expect(UserMapper.new.fetch.first.customer.forename).to eq "Peter"
    end
  end

  describe "loading of role" do
    before do
      user.add_role "admin"
      user.add_role "driver"

      subject.save user
    end

    let(:roles) { subject.fetch.first.roles }

    it "loads the associated roles" do
      expect(roles.size).to eq 2
      expect(roles).to include :admin
      expect(roles).to include :driver
    end
  end
end
