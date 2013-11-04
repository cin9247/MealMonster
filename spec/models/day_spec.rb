require_relative "../../app/models/day"

describe Day do
  let(:offering_mapper) { double(:offering_mapper) }
  let(:order_mapper) { double(:order_mapper) }
  let(:offering_source) { ->(attrs={}) { OpenStruct.new(attrs) } }
  let(:order_source) { ->(attrs={}) { OpenStruct.new(attrs) } }

  before do
    subject.offering_mapper = offering_mapper
    subject.order_mapper = order_mapper
    subject.offering_source = offering_source
    subject.order_source = order_source
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

  describe "#new_offering" do
    it "returns a new offering linked to the day" do
      offering = subject.new_offering
      expect(offering.day).to eq subject
    end

    it "passes arguments through" do
      offering = subject.new_offering(foo: "bar")
      expect(offering.foo).to eq "bar"
    end
  end

  describe "#new_order" do
    it "returns a new order linked to the day" do
      order = subject.new_order
      expect(order.day).to eq subject
    end

    it "passes arguments through" do
      order = subject.new_order(foo: "bar")
      expect(order.foo).to eq "bar"
    end
  end

  describe "#add_order" do
    let(:order) { double(:order) }

    it "uses order_mapper to save the order" do
      order_mapper.should_receive(:save).with order
      subject.add_order order
    end
  end
end
