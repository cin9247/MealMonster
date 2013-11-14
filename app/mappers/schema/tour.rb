class Schema::Tour < Sequel::Model
  many_to_many :customers
end
