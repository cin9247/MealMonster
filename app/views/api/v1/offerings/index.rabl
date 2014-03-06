collection @offerings => :offerings

attributes :id, :date, :name

child :meals, object_root: false do
  attributes :name, :bread_units, :kilojoules
end
