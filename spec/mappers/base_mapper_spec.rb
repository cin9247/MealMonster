require "spec_helper"

class Foo < Struct.new(:name, :created_at, :updated_at)
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
  let(:current_date) { DateTime.new(2014, 2, 2, 14, 32, 20, '+2') }
  let(:current_date_utc) { DateTime.new(2014, 2, 2, 12, 32, 20) }

  before do
    DB.create_table :foos do
      primary_key :id
      String :name
      DateTime :created_at
      DateTime :updated_at
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
      subject.save(foo, current_date)
    end

    it "adds the record to the database" do
      expect(subject.fetch.map(&:name)).to eq ["Peter"]
    end

    it "sets the id of the record" do
      expect(foo.id).to_not be_nil
    end

    it "sets created_at and updated_at to the current time" do
      expect(foo.created_at).to eq current_date_utc
      expect(foo.updated_at).to eq current_date_utc
    end

    it "saves the created_at and updated_at to the database" do
      expect(subject.fetch.first.created_at).to eq current_date_utc
      expect(subject.fetch.first.updated_at).to eq current_date_utc
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
      subject.save foo, current_date
      subject.save foo_old
      foo.name = "Dieter"
      subject.update foo, DateTime.new(2014, 1, 1)
    end

    it "sets the name to Dieter" do
      expect(subject.find(foo.id).name).to eq "Dieter"
    end

    it "doesn't change any other record" do
      expect(subject.find(foo_old.id).name).to eq "Agate"
    end

    it "sets updated_at to the current date" do
      expect(subject.find(foo.id).updated_at).to eq Date.new(2014, 1, 1)
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

      it "raises exception" do
        expect {
          result
        }.to raise_error(BaseMapper::RecordNotFound)
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

    context "given a set of array, some existing some not" do
      let(:id) { [@id_1, @id_2, 100] }

      it "raises an exception" do
        expect {
          result
        }.to raise_error(BaseMapper::RecordNotFound)
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

  describe "#delete" do
    let(:foo) { Foo.new("Peter") }

    before do
      subject.save foo
    end

    it "removes the record from the database" do
      expect(subject.fetch.size).to eq 1
      subject.delete foo
      expect(subject.fetch.size).to eq 0
    end
  end
end
