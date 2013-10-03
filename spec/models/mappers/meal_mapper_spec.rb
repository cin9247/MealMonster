require "spec_helper"

describe MealMapper do
  describe "#fetch" do
    it "is returns an empty array after initialization" do
      expect(subject.fetch).to eq []
    end
  end

  describe "#save" do
    let(:meal) { double(:meal, id: nil, name: "Reis") }

    it "adds the record to the database" do
      subject.save(meal)
      expect(subject.fetch.map(&:name)).to eq ["Reis"]
    end
  end

  describe "#clean" do
    before do
      subject.save double(:meal, id: nil, name: "Reis")
    end

    it "removes all existing records" do
      subject.clean
      expect(subject.fetch).to eq []
    end
  end

  describe "#find" do
    before do
      @id_1 = subject.save(double(:meal, id: nil, name: "Reis")).id
      @id_2 = subject.save(double(:meal, id: nil, name: "Spaghetti")).id
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
