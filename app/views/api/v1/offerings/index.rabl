collection @offerings => :offerings

attributes :id, :date

child :meals, object_root: false do
  attributes :name
end
