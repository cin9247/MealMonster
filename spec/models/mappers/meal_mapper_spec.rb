require "spec_helper"

describe MealMapper do
  describe "#fetch" do
    it "returns an empty array after initialization" do
      expect(subject.fetch).to eq []
    end
  end

  describe "#save" do
    let(:meal) { Meal.new(nil, name: "Reis") }

    before do
      subject.save(meal)
    end

    it "adds the record to the database" do
      expect(subject.fetch.map(&:name)).to eq ["Reis"]
    end

    it "sets the id of the record" do
      expect(meal.id).to_not be_nil
    end
  end

  describe "#clean" do
    before do
      subject.save Meal.new(nil, name: "Reis")
    end

    it "removes all existing records" do
      subject.clean
      expect(subject.fetch).to eq []
    end
  end

  describe "#find" do
    before do
      @id_1 = subject.save Meal.new(nil, name: "Reis")
      @id_2 = subject.save Meal.new(nil, name: "Spaghetti")
    end

    let(:result) { subject.find id }

    context "given unexisting id" do
      let(:id) { 0 }

      it "returns nil" do
        expect(result).to be_nil
      end
    end

    context "given existing id" do
      let(:id) { @id_2 }

      it "returns the existing record" do
        expect(result.name).to eq "Spaghetti"
      end
    end
  end
end
