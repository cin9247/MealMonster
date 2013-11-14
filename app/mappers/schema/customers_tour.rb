class Schema::CustomersTour < Sequel::Model
  many_to_one :customer
  many_to_one :tour
end
