class Schema::Offering < Sequel::Model
  many_to_one :menu
end
