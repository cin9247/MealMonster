require_relative "../../app/models/user"

describe User do
  describe "#add_role" do
    it "adds the role" do
      subject.add_role "driver"
      subject.add_role "administrator"
      expect(subject.roles).to eq ["driver", "administrator"]
    end
  end
end
