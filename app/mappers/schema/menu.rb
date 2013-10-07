class Schema::Menu < Sequel::Model
  many_to_many :meals
  one_to_many :offering
end
