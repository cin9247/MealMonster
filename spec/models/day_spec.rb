require_relative "../../app/models/day"

describe Day do
  let(:offering_mapper) { double(:offering_mapper) }
  let(:offering_source) { ->(attrs={}) { OpenStruct.new(attrs) } }

  before do
    subject.offering_mapper = offering_mapper
    subject.offering_source = offering_source
  end

  describe "#offer!" do
    let(:menu) { double(:menu) }
    let(:offering) { double(:offering) }
    let(:date) { Date.new(2013, 4, 5) }

    let(:subject) { Day.new(date: date) }

    it "accepts menus and wraps them in offerings" do
      subject.should_receive(:new_offering).with(menu: menu).and_return offering
      offering_mapper.should_receive(:save).with(offering)
      subject.offer! menu
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
