require "spec_helper"

describe TourMapper do
  let(:tour) { Tour.new name: "Tour #1", customers: [customer_1, customer_2] }
  let(:customer_1) { Customer.new forename: "Peter" }
  let(:customer_2) { Customer.new forename: "Dieter" }
  let(:customer_3) { Customer.new forename: "Hans" }

  before do
    @c_ids = []
    @c_ids << CustomerMapper.new.save(customer_1)
    @c_ids << CustomerMapper.new.save(customer_2)
    @c_ids << CustomerMapper.new.save(customer_3)
  end

  describe "#save" do
    before do
      subject.save tour
    end

    let(:result) { subject.fetch }

    it "saves the tour" do
      expect(result.first.name).to eq "Tour #1"
    end

    it "saves the customers" do
      expect(result.first.customers.size).to eq 2
      expect(result.first.customers.first.forename).to eq "Peter"
    end
  end

  describe "ordering of customers" do
    it "orders the customer properly" do
      tour_id = subject.save Tour.new(name: "Tour", customers: [])
      DB[:customers_tours].insert customer_id: @c_ids[0], tour_id: tour_id, position: 0
      DB[:customers_tours].insert customer_id: @c_ids[1], tour_id: tour_id, position: 2
      DB[:customers_tours].insert customer_id: @c_ids[2], tour_id: tour_id, position: 1

      tour = subject.fetch.first
      expect(tour.customers.map(&:id)).to eq [@c_ids[0], @c_ids[2], @c_ids[1]]
    end
  end
end
