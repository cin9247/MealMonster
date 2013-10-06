require_relative "../../app/models/day"

describe Day do
  let(:offering_mapper) { double(:offering_mapper) }

  before do
    subject.offering_mapper = offering_mapper
  end

  describe "attributes" do
    it "knows about its date" do
      d = Day.new(date: Date.new(2013, 4, 6))
      expect(d.date).to eq Date.new(2013, 4, 6)
    end
  end

  describe "#kitchen=" do
    let(:kitchen) { double(:kitchen) }

    it "sets the kitchen" do
      subject.kitchen = kitchen
      expect(subject.kitchen).to eq kitchen
    end
  end

  describe "#offer!" do
    let(:offering) { double(:menu) }
    let(:date) { Date.new(2013, 4, 5) }

    let(:subject) { Day.new(date: date) }

    it "saves the provided offering" do
      offering_mapper.should_receive(:save).with(offering)
      subject.offer! offering
    end
  end

  describe "#offerings" do
    let(:date) { Date.new(2013, 10, 3) }
    let(:subject) { Day.new(date: date) }

    it "asks the offering mapper for all offerings for that day" do
      offerings = [double(:offering)]
      offering_mapper.should_receive(:fetch_by_date).with(date).and_return offerings
      expect(subject.offerings).to eq offerings
    end
  end

  describe "#new_offering" do
    subject { Day.new date: Date.new(2013, 4, 6) }

    before do
      subject.offering_source = ->(attrs={}) { OpenStruct.new(attrs) }
    end

    it "returns a new offering linked to the day" do
      offering = subject.new_offering
      expect(offering.day).to eq subject
    end

    it "passes arguments through" do
      offering = subject.new_offering(foo: "bar")
      expect(offering.foo).to eq "bar"
    end
  end
end
