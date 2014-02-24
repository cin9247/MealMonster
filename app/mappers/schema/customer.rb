class Schema::Customer < Sequel::Model
  many_to_one :address
  many_to_one :catchment_area
end
