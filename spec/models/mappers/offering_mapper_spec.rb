require "spec_helper"

describe OfferingMapper do
  describe "#save" do
    let(:meal) { Meal.new name: "Hackbraten" }
    let(:date) { Date.new(2013, 4, 6) }
    let(:menu) { Menu.new meals: [meal] }
    let(:offering) { Offering.new menu: menu, date: date }

    context "existing menu" do
      before do
        MenuMapper.new.save menu
      end

      it "saves the offering" do
        subject.save offering

        expect(subject.fetch.length).to eq 1
        expect(subject.fetch.first.date).to eq date
        expect(subject.fetch.first.menu.id).to eq menu.id
      end
    end

    context "non existing menu" do
      it "saves the menu first" do
        subject.save offering

        expect(subject.fetch.first.menu.id).to eq menu.id
      end
    end
  end

  describe "#fetch_by_date" do
    let(:menu) { Menu.new }
    let(:offering_1) { Offering.new date: Date.new(2013, 5, 6), menu: menu }
    let(:offering_2) { Offering.new date: Date.new(2013, 5, 6), menu: menu }
    let(:offering_3) { Offering.new date: Date.new(2013, 5, 7), menu: menu }

    before do
      subject.save offering_1
      subject.save offering_2
      subject.save offering_3
    end

    it "returns the offerings by date" do
      result = subject.fetch_by_date Date.new(2013, 5, 6)

      expect(result.length).to eq 2
      expect(result.map(&:id).sort).to eq [offering_1.id, offering_2.id].sort
    end
  end
end
