collection @tours => :tours

attributes :id, :name

child(:driver => :driver) do
  attributes :id, :name
end
