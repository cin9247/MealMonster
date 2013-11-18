object false

child(@tour) do
  attributes :id, :name
  child({@stations => :stations}, {object_root: false}) do
    child :customer do
      attributes :forename
      attributes :surname
    end
    child :order, object_root: false do
      child :offering do
        attributes :id
      end
    end
  end
end
