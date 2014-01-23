require_relative "../../app/models/user"

describe User do
  describe "#add_role" do
    it "adds the role" do
      subject.add_role "driver"
      subject.add_role "admin"
      expect(subject.roles).to eq [:driver, :admin]
    end

    it "raises an exception if the role is unknown" do
      expect {
        subject.add_role "butcher"
      }.to raise_error(UnknownRoleError)
    end
  end

  describe "#set_role" do
    it "sets roles to just the provided role" do
      subject.add_role "driver"
      subject.set_role "admin"
      expect(subject.roles).to eq [:admin]
    end
  end

  describe "#has_role?" do
    context "has the desired role" do
      it "returns true" do
        subject.add_role "driver"
        expect(subject.has_role? "driver").to eq true
      end

      it "also converts strings to symbols and vice verca" do
        subject.add_role :driver
        expect(subject.has_role? "driver").to eq true
      end
    end

    context "hasn't the desired role" do
      it "returns false" do
        subject.add_role "driver"
        expect(subject.has_role? "user").to eq false
      end
    end
  end
end
