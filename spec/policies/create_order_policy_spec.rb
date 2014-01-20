require "interactor_spec_helper"
require_relative "../../app/policies/create_order_policy"
require "ostruct"

describe Policy::CreateOrderPolicy do
  subject { Policy::CreateOrderPolicy.new(user) }
  let(:request) { OpenStruct.new(customer_id: 4, offering_id: 2) }

  before do
  end

  context "logged in as admin" do
    let(:user) { double(:user) }

    before do
      user.should_receive(:has_role?).with(:admin).and_return true
    end

    it "can order anything" do
      expect(subject.can?(request)).to eq true
    end
  end

  context "logged in as customer" do
    let(:user) { double(:user, customer?: true, customer: customer, admin?: false) }

    before do
      user.should_receive(:has_role?).with(:admin).and_return false
      user.should_receive(:has_role?).with(:customer).and_return true
    end

    context "customer is not linked to this account" do
      let(:customer) { double(:customer, id: 2) }

      it "cannot be ordered" do
        expect(subject.can?(request)).to eq false
      end
    end

    context "customer is linked to this account" do
      let(:customer) { double(:customer, id: 4) }

      it "can be ordered" do
        expect(subject.can?(request)).to eq true
      end
    end
  end
end
