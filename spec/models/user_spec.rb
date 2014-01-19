require_relative "../../app/models/user"

describe User do
  describe "#add_role" do
    it "adds the role" do
      subject.add_role "driver"
      subject.add_role "administrator"
      expect(subject.roles).to eq ["driver", "administrator"]
    end
  end

  describe "#set_role" do
    it "sets roles to just the provided role" do
      subject.add_role "driver"
      subject.set_role "admin"
      expect(subject.roles).to eq ["admin"]
    end
  end
end
