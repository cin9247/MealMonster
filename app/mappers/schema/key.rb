class Schema::Key < Sequel::Model
  many_to_one :address
end
