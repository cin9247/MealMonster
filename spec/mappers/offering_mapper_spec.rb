require "spec_helper"

describe OfferingMapper do
  let(:meal) { Meal.new name: "Hackbraten" }
  let(:menu) { Menu.new meals: [meal] }
  let(:price_class) { PriceClass.new(name: "Preisklasse 1", price: Money.new(2010)) }

  before do
    PriceClassMapper.new.save price_class
  end

  describe "#save" do
    let(:date) { Date.new(2013, 4, 6) }
    let(:offering) { Offering.new menu: menu, day: double(:day, date: date), price_class: price_class }

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

    describe "price class" do
      it "saves the price class" do
        subject.save offering

        expect(subject.fetch.first.price_class.name).to eq "Preisklasse 1"
      end
    end
  end

  describe "#fetch_by_date" do
    let(:offering_1) { Offering.new day: Day.new(date: Date.new(2013, 5, 6)), menu: menu, price_class: price_class }
    let(:offering_2) { Offering.new day: Day.new(date: Date.new(2013, 5, 6)), menu: menu, price_class: price_class }
    let(:offering_3) { Offering.new day: Day.new(date: Date.new(2013, 5, 7)), menu: menu, price_class: price_class }

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
    let(:offering_1) { Offering.new day: Day.new(date: Date.new(2013, 5, 6)), menu: menu, price_class: price_class }
    let(:offering_2) { Offering.new day: Day.new(date: Date.new(2013, 5, 6)), menu: menu, price_class: price_class }
    let(:offering_3) { Offering.new day: Day.new(date: Date.new(2013, 5, 7)), menu: menu, price_class: price_class }
    let(:offering_4) { Offering.new day: Day.new(date: Date.new(2013, 5, 8)), menu: menu, price_class: price_class }

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
