require "spec_helper"

describe OfferingMapper do
  let(:meal) { Meal.new name: "Hackbraten" }
  let(:menu) { Menu.new meals: [meal] }

  describe "#save" do
    let(:date) { Date.new(2013, 4, 6) }
    let(:offering) { Offering.new menu: menu, day: double(:day, date: date) }

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
    let(:offering_1) { Offering.new day: Day.new(date: Date.new(2013, 5, 6)), menu: menu }
    let(:offering_2) { Offering.new day: Day.new(date: Date.new(2013, 5, 6)), menu: menu }
    let(:offering_3) { Offering.new day: Day.new(date: Date.new(2013, 5, 7)), menu: menu }

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

    it "sets the menu" do
      result = subject.fetch_by_date Date.new(2013, 5, 6)

      expect(result.first.menu.id).to eq menu.id
    end
  end

  describe "#fetch_by_date_range" do
    let(:offering_1) { Offering.new day: Day.new(date: Date.new(2013, 5, 6)), menu: menu }
    let(:offering_2) { Offering.new day: Day.new(date: Date.new(2013, 5, 6)), menu: menu }
    let(:offering_3) { Offering.new day: Day.new(date: Date.new(2013, 5, 7)), menu: menu }
    let(:offering_4) { Offering.new day: Day.new(date: Date.new(2013, 5, 8)), menu: menu }

    before do
      subject.save offering_1
      subject.save offering_2
      subject.save offering_3
      subject.save offering_4
    end

    it "returns all offerings within that range" do
      result = subject.fetch_by_date_range(Date.new(2013, 5, 6), Date.new(2013, 5, 7))
      expect(result.size).to eq 3
      ids = result.map(&:id)
      expect(ids).to include offering_1.id
      expect(ids).to include offering_2.id
      expect(ids).to include offering_3.id
    end
  end
end
