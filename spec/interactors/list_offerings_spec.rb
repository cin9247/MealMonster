require_relative "../../app/interactors/list_offerings"

require "interactor_spec_helper"

describe Interactor::ListOfferings do
  let(:offering_gateway) { dummy_gateway }
  let(:day_source) { ->(args) { OpenStruct.new(args) } }

  context "given a start and end date" do
    let(:from) { Date.new(2013, 10, 4) }
    let(:to)   { Date.new(2013, 10, 5) }
    let(:subject) { Interactor::ListOfferings.new(from, to) }

    before do
      offering_gateway.save double(:offering, date: from)
      offering_gateway.save double(:offering, date: to)
      offering_gateway.save double(:offering, date: Date.new(2013, 10, 6))

      def offering_gateway.fetch_by_date(date)
        all.select { |i| i.date == date }
      end

      subject.offering_gateway = offering_gateway
      subject.day_source       = day_source
    end

    let(:result) { subject.run.object }

    it "returns all offerings in that time span" do
      expect(result.size).to eq 2
      expect(result.first.date).to eq from
      expect(result.last.date).to eq to
    end
  end
end