require "interactor_spec_helper"
require_relative "../../app/policies/create_order_policy"
require "ostruct"

describe Policy::CreateOrderPolicy do
  subject { Policy::CreateOrderPolicy.new(user) }
  let(:request) { OpenStruct.new(customer_id: 4, offering_id: 2) }
  let(:user) {
    Class.new do
      def has_role?
      end
    end.new
   }

  before do
  end

  context "logged in as admin" do
    let(:user) { double(:user, admin?: true) }

    it "can order anything" do
      expect(subject.can?(request)).to eq true
    end
  end

  context "logged in as customer" do
    let(:user) { double(:user, customer?: true, customer: customer, admin?: false) }

    context "customer is not linked to this account" do
      let(:customer) { double(:customer, id: 2) }

      it "cannot be ordered" do
        expect(subject.can?(request)).to eq false
      end
    end

    context "customer is linked to this account" do
      let(:customer) { double(:customer, id: 4) }

      it "can be ordered" do
        expect(subject.can?(request, DateTime.new(2013, 4, 23))).to eq true
      end
    end
  end
end
