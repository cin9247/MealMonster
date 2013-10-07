class Schema::Meal < Sequel::Model
  many_to_many :menus
end
