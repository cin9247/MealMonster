require_relative "../../app/policies/add_address_to_customer_policy"

describe Policy::AddAddressToCustomerPolicy do
  let(:user) { double(:user) }
  let(:request) { double(:request) }
  subject { described_class.new(user) }

  describe "logged in as admin" do
    before do
      expect(user).to receive(:has_role?).with(:admin).and_return true
    end

    it "allows access" do
      expect(subject.can?(request)).to eq true
    end
  end

  describe "logged in as user" do
    before do
      expect(user).to receive(:has_role?).with(:admin).and_return false
      expect(user).to receive(:has_role?).with(:user).and_return true
    end

    it "allows access" do
      expect(subject.can?(request)).to eq true
    end
  end

  describe "logged in as customer" do
    before do
      expect(user).to receive(:has_role?).with(:admin).and_return false
      expect(user).to receive(:has_role?).with(:user).and_return false
    end

    it "allows access" do
      expect(subject.can?(request)).to eq false
    end
  end

  describe "logged in as driver" do
    before do
      expect(user).to receive(:has_role?).with(:admin).and_return false
      expect(user).to receive(:has_role?).with(:user).and_return false
    end

    it "allows access" do
      expect(subject.can?(request)).to eq false
    end
  end
end
