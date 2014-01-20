require "interactor_spec_helper"
require_relative "../../app/interactors/base"

describe Interactor::Base do
  let(:dummy_interactor_class) do
    Class.new(Interactor::Base) do
      register_boundary :dummy_source, -> { "Default" }

      def run
        dummy_source.upcase
      end
    end
  end

  describe "#register_boundary" do
    let(:subject) { dummy_interactor_class.new(double) }

    context "boundary set" do
      let(:dummy_source) { "No default" }

      before do
        subject.dummy_source = dummy_source
      end

      it "uses the set boundary" do
        expect(subject.run).to eq "NO DEFAULT"
      end
    end

    context "boundary not set" do
      it "uses the default" do
        expect(subject.run).to eq "DEFAULT"
      end
    end
  end
end
