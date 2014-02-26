collection @orders => :orders

attributes :id, :date

child :offerings, object_root: false do
  attributes :id, :name
  child :meals, object_root: false do
    attributes :id, :name
  end
end

