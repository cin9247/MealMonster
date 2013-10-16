require_relative "../../app/models/days"

describe Days do
  describe "#offerings" do
    let(:from) { double(:from) }
    let(:to) { double(:to) }
    subject { Days.new(from: from, to: to) }

    it "asks the offering mapper for all offerings in that time span" do
      offering_mapper = double(:offering_mapper)
      subject.offering_mapper = offering_mapper
      result = double(:result)
      offering_mapper.should_receive(:fetch_by_date_range).with(from, to).and_return result
      expect(subject.offerings).to eq result
    end
  end

  describe "#each" do
    subject { Days.new(from: Date.new(2013, 2, 2), to: Date.new(2013, 2, 4)) }

    it "iterates over all dates" do
      subject.day_source = ->(args={}) { OpenStruct.new(args) }
      dates = [Date.new(2013, 2, 2), Date.new(2013, 2, 3), Date.new(2013, 2, 4)]
      i = 0
      subject.each do |d|
        expect(d.date).to eq dates[i]
        i += 1
      end
    end
  end
end
