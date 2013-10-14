class Schema::Order < Sequel::Model
  many_to_one :customer
  many_to_one :offering
end
