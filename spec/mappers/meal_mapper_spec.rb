require "spec_helper"

describe MealMapper do
  describe "#save" do
    let(:price_class) { PriceClass.new name: "PK" }

    it "grabs the price_class_id" do
      PriceClassMapper.new.save price_class

      meal = Meal.new name: "Gericht", price_class: price_class

      subject.save meal

      expect(subject.fetch.first.price_class.name).to eq "PK"
    end
  end
end
