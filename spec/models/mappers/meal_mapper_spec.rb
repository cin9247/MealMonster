require_relative "../../../app/models/mappers/meal_mapper"

describe MealMapper do
  describe "#fetch" do
    it "is returns an empty array after initialization" do
      expect(subject.fetch).to eq []
    end
  end

  describe "#save" do
    let(:meal) { double(:meal) }

    it "adds the record to the database" do
      subject.save(meal)
      expect(subject.fetch).to eq [meal]
    end
  end

  describe "#clean" do
    before do
      subject.save double(:meal)
    end

    it "removes all existing records" do
      subject.clean
      expect(subject.fetch).to eq []
    end
  end

  describe "#find" do
    let(:m_1) { double(:meal, id: 2) }
    let(:m_2) { double(:meal, id: 5) }

    before do
      subject.save m_1
      subject.save m_2
    end

    let(:result) { subject.find id }

    context "given unexisting id" do
      let(:id) { 9 }

      it "returns nil" do
        expect(result).to be_nil
      end
    end

    context "given existing id" do
      let(:id) { 5 }

      it "returns the existing record" do
        expect(result).to eq m_2
      end
    end
  end
end
