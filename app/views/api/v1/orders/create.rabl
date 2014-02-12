object false

child @order do
  attributes :id, :note

  child :customer do
    attributes :forename, :surname
  end
end
