object false

child @ticket do
  attributes :id, :title, :body

  child :customer do
    attributes :forename, :surname
  end
end
