require_relative "../../app/models/meal"

describe Meal do
  it "starts with blank attributes" do
    expect(subject.name).to be_nil
  end

  it "grabs the name from attributes hash" do
    m = Meal.new name: "Schnitzel"
    expect(m.name).to eq "Schnitzel"
  end

  describe "#offer!" do
    let(:kitchen) { double(:kitchen) }

    before do
      subject.kitchen = kitchen
    end

    it "adds itself to the kitchen meals" do
      kitchen.should_receive(:add_meal).with(subject)
      subject.offer!
    end
  end
end
