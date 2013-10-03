require "spec_helper"

class Foo < Struct.new(:id, :name)
  def persisted?
    false
  end
end

class FooMapper < BaseMapper
  def object_to_hash(record)
    {
      name: record.name
    }
  end

  def hash_to_object(hash)
    Foo.new hash[:id], hash[:name]
  end

  private
    def table_name
      :foos
    end
end

describe FooMapper do
  before do
    DB.create_table :foos do
      primary_key :id
      String :name
    end
  end

  after do
    DB.drop_table :foos
  end

  describe "#fetch" do
    it "returns an empty array after initialization" do
      expect(subject.fetch).to eq []
    end
  end

  describe "#save" do
    let(:foo) { Foo.new(nil, "Peter") }

    before do
      subject.save(foo)
    end

    it "adds the record to the database" do
      expect(subject.fetch.map(&:name)).to eq ["Peter"]
    end

    it "sets the id of the record" do
      expect(foo.id).to_not be_nil
    end

    it "does not allow saving an object twice" do
      expect {
        subject.save menu
      }.to raise_error
    end
  end

  describe "#update" do
    let(:foo) { Foo.new(nil, "Peter") }
    let(:foo_old) { Foo.new(nil, "Agate") }

    before do
      subject.save foo
      subject.save foo_old
      foo.name = "Dieter"
      subject.update foo
    end

    it "sets the name to Dieter" do
      expect(subject.find(foo.id).name).to eq "Dieter"
    end

    it "doesn't change any other record" do
      expect(subject.find(foo_old.id).name).to eq "Agate"
    end

    it "raises error when record hasn't been saved yet" do
      expect {
        subject.update Foo.new
      }.to raise_error
    end
  end

  describe "#clean" do
    before do
      subject.save Foo.new(nil, "Peter")
    end

    it "removes all existing records" do
      subject.clean
      expect(subject.fetch).to eq []
    end
  end

  describe "#find" do
    before do
      @id_1 = subject.save Foo.new(nil, "Peter")
      @id_2 = subject.save Foo.new(nil, "Juno")
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
        expect(result.name).to eq "Juno"
      end
    end
  end
end
