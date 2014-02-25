require "spec_helper"

describe KeyMapper do
  describe "#fetch_by_date_and_tour" do
    before do
      customers = [create_customer_with_town("Peter", "Blub", "Stuttgart"), create_customer_with_town("Bob", "Muh", "Karlsruhe")]
      add_key_for_customer(customers.first, "Key 1")
      add_key_for_customer(customers.first, "Key 2")
      add_key_for_customer(customers.last, "unused key")
      @tour_id = create_tour("Tour", customers.map(&:id)).id
      @date = Date.new(2014, 2, 2)
      o = create_offering(@date, "Menu 1")
      create_order(customers.first.id, o.id)
    end

    it "returns only the keys for people which have ordered food on this day and are in this tour" do
      result = subject.fetch_by_date_and_tour(@date, @tour_id)
      expect(result.size).to eq 2
      expect(result.map(&:name)).to include "Key 1"
      expect(result.map(&:name)).to include "Key 2"
    end
  end
end
