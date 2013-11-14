collection @tours => :tours

attributes :id, :name

child({:customers => :stations}, {object_root: false}) do
  node(:customer) do |c|
    {forename: c.forename, surname: c.surname}
  end
end



#child :meals, object_root: false do
#  attributes :name, :bread_units, :kilojoules
#end
