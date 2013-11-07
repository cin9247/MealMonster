require "interactor_spec_helper"
require_relative "../../app/interactors/set_price_class_for_meal"

describe Interactor::SetPriceClassForMeal do
  subject { Interactor::SetPriceClassForMeal.new(12, 2) }
  let(:meal)         { OpenStruct.new(id: 12) }
  let(:price_class)  { OpenStruct.new(id: 2) }
  let(:meal_gateway) { dummy_gateway }
  let(:price_class_gateway) { dummy_gateway }

  before do
    subject.meal_gateway = meal_gateway
    subject.price_class_gateway = price_class_gateway
    meal_gateway.save meal
    price_class_gateway.save price_class
  end

  it "m" do
    subject.run
    expect(meal_gateway.find(12).price_class).to eq price_class
  end
end
