require "interactor_spec_helper"
require_relative "../../app/policies/create_order_policy"
require "ostruct"

shared_examples "authorized" do
  let(:user_stub_class) do
    Class.new do
      def initialize(role)
        @role = role
      end

      def has_role?(role)
        @role == role
      end
    end
  end
  let(:policy) { described_class.new(user) }
  let(:user) do
    user_stub_class.new(role)
  end

  it "is authorized to take actions" do
    expect(policy.can?(request)).to eq true
  end
end

shared_examples "not authorized" do
  let(:user_stub_class) do
    Class.new do
      def initialize(role)
        @role = role
      end

      def has_role?(role)
        @role == role
      end
    end
  end
  let(:policy) { described_class.new(user) }
  let(:user) do
    user_stub_class.new(role)
  end

  it "is authorized to take actions" do
    expect(policy.can?(request)).to eq false
  end
end

describe Policy::CreateOrderPolicy do
  subject { described_class.new(user) }
  let(:request) { OpenStruct.new(customer_id: 4, offering_id: 2) }

  context "logged in as admin" do
    let(:role) { :admin }
    it_behaves_like "authorized"
  end

  context "logged in as manager" do
    let(:role) { :manager }
    it_behaves_like "authorized"
  end

  context "logged in as customer" do
    let(:role) { :customer }
    before do
      user.stub()
    end
    it_behaves_like "not authorized"
  end

  context "logged in as customer" do
    let(:user) { double(:user, customer: customer) }

    before do
      user.should_receive(:has_role?).with(:admin).and_return false
      user.should_receive(:has_role?).with(:manager).and_return false
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

    context "customer isn't linked to any account" do
      let(:customer) { nil }

      it "cannot be ordered" do
        expect(subject.can?(request)).to eq false
      end
    end
  end
end
