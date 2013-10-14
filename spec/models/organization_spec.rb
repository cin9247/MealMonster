require_relative "../../app/models/organization"
require "ostruct"

describe Organization do
  let(:customer_mapper) { double(:customer_mapper) }

  before do
    subject.kitchen_source = -> { OpenStruct.new }
    subject.customer_mapper = customer_mapper
  end

  describe "#customers" do
    it "asks customer_mapper for customers" do
      result = double(:result)
      customer_mapper.should_receive(:fetch).and_return(result)
      expect(subject.customers).to eq result
    end
  end

  describe "#new_customer" do
    before do
      subject.customer_source = ->(options={}) { OpenStruct.new(options) }
    end

    it "creates a new instance and passes arguments through" do
      expect(subject.new_customer(forename: "Peter").forename).to eq "Peter"
    end

    it "sets the organization" do
      expect(subject.new_customer.organization).to eq subject
    end
  end

  describe "#add_customer" do
    let(:customer) { double(:customer) }

    it "saves the customer using the customer_mapper" do
      customer_mapper.should_receive(:save).with customer
      subject.add_customer customer
    end
  end

  describe "#day" do
    before do
      subject.day_source = ->(args = {}) { OpenStruct.new(args) }
    end

    it "returns an object which knows about its date" do
      expect(subject.day("2013-10-03").date).to eq Date.new(2013, 10, 3)
    end

    it "accepts date objects as well" do
      expect(subject.day(Date.new(2013, 10, 3)).date).to eq Date.new(2013, 10, 3)
    end

    it "returns an object which knows about the organization" do
      expect(subject.day("2013-10-03").organization).to eq subject
    end
  end

  describe "#days" do
    before do
      subject.day_source = ->(args = {}) { OpenStruct.new(args) }
    end

    it "returns an array of days" do
      days = subject.days(Date.new(2013, 10, 3)..Date.new(2013, 10, 7))
      expect(days.length).to eq 5
      expect(days.map(&:date)).to eq [
        Date.new(2013, 10, 3),
        Date.new(2013, 10, 4),
        Date.new(2013, 10, 5),
        Date.new(2013, 10, 6),
        Date.new(2013, 10, 7),
      ]
      expect(days.first.organization).to eq subject
    end

    xit "it also accepts strings"
  end

  describe "#orders" do
    let(:order_mapper) { double(:order_mapper) }
    let(:orders) { double(:orders) }

    before do
      subject.order_mapper = order_mapper
    end

    it "asks the order mapper for all orders" do
      order_mapper.should_receive(:fetch).and_return orders
      expect(subject.orders).to eq orders
    end
  end
end
