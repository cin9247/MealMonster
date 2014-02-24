class Schema::Address < Sequel::Model
  one_to_one :customer
  one_to_many :keys
end
