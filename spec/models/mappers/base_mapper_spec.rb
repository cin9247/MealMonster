require "spec_helper"

class Foo < Struct.new(:name)
  attr_accessor :id

  def persisted?
    false
  end
end

class FooMapper < BaseMapper
  def hash_from_object(record)
    {
      name: record.name
    }
  end

  def object_from_hash(hash)
    Foo.new hash[:name]
  end

  private
    def table_name
      :foos
    end

    def schema_class
      Class.new(Sequel::Model(table_name)) do
      end
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
    let(:foo) { Foo.new("Peter") }

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
    let(:foo) { Foo.new("Peter") }
    let(:foo_old) { Foo.new("Agate") }

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

  describe "#find" do
    before do
      @id_1 = subject.save Foo.new("Peter")
      @id_2 = subject.save Foo.new("Juno")
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

      it "sets the id of the record" do
        expect(result.id).to_not be_nil
      end
    end
  end

  describe "#fetch" do
    let(:foo_1) { Foo.new("Peter") }
    let(:foo_2) { Foo.new("Juno") }

    before do
      @id_1 = subject.save foo_1
      @id_2 = subject.save foo_2
    end

    it "sets the id of each record" do
      expect(subject.fetch.map(&:id).sort).to eq [@id_1, @id_2].sort
    end
  end
end
