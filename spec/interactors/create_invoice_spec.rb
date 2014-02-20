require "interactor_spec_helper"
require_relative "../../app/interactors/create_invoice"

describe Interactor::CreateInvoice do
  subject { Interactor::CreateInvoice.new(request) }
  let(:month) { OpenStruct.new(month: 11, year: 2014) }
  let(:some_date) { Date.new(2014, 11, 2) }
  let(:some_other_date) { Date.new(2014, 11, 5) }
  let(:request) { OpenStruct.new(month: month) }
  let(:result) { subject.run.object }
  let(:order_gateway) { double(:order_gateway) }

  before do
    expect(order_gateway).to receive(:find_by_month).with(month).and_return(orders)
    subject.order_gateway = order_gateway
  end

  context "given no orders" do
    let(:orders) { [] }

    it "returns an invoice for the requested month" do
      expect(result.month).to eq month
    end

    it "returns 0 order lines" do
      expect(result.line_items).to eq []
    end
  end

  context "given one order with one offering" do
    let(:orders) { [double(date: some_date, offerings: [double(name: "Schnitzel", price: 0)])] }

    it "returns one order line" do
      expect(result.line_items.size).to eq 1
    end

    it "returns the date" do
      expect(result.line_items.first.date).to eq some_date
    end

    it "contains the name of the offering" do
      expect(result.line_items.first.name).to eq "Schnitzel"
    end
  end

  context "given one order with two offerings" do
    let(:orders) { [double(date: some_date, offerings: [double(name: "Schnitzel", price: 0), double(name: "Pudding", price: 0)])] }

    it "returns one order line" do
      expect(result.line_items.size).to eq 2
    end

    it "returns the date" do
      expect(result.line_items.first.date).to eq some_date
      expect(result.line_items.last.date).to eq some_date
    end

    it "contains the name of the offering" do
      expect(result.line_items.first.name).to eq "Schnitzel"
      expect(result.line_items.last.name).to eq "Pudding"
    end
  end

  context "given two orders with two offerings each" do
    let(:orders) { [
      double(date: some_date, offerings: [double(name: "Schnitzel", price: 21), double(name: "Pudding", price: 14)]),
      double(date: some_other_date, offerings: [double(name: "Apfel", price: 18), double(name: "Quark", price: 23)])
    ] }

    it "returns one order line" do
      expect(result.line_items.size).to eq 4
    end

    it "returns the date" do
      expect(result.line_items[0].date).to eq some_date
      expect(result.line_items[1].date).to eq some_date
      expect(result.line_items[2].date).to eq some_other_date
      expect(result.line_items[3].date).to eq some_other_date
    end

    it "returns the prices" do
      expect(result.line_items[0].price).to eq 21
      expect(result.line_items[1].price).to eq 14
      expect(result.line_items[2].price).to eq 18
      expect(result.line_items[3].price).to eq 23
    end

    it "contains the name of the offering" do
      expect(result.line_items[0].name).to eq "Schnitzel"
      expect(result.line_items[1].name).to eq "Pudding"
      expect(result.line_items[2].name).to eq "Apfel"
      expect(result.line_items[3].name).to eq "Quark"
    end
  end
end
