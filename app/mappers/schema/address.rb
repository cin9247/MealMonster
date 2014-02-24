class Schema::Address < Sequel::Model
  one_to_one :customer
end
