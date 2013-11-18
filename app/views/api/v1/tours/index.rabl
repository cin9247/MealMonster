collection @tours => :tours

attributes :id, :name

child({:customers => :stations}, {object_root: false}) do
  node(:customer) do |c|
    {
      id: c.id,
      forename: c.forename,
      surname: c.surname
    }
  end
end
