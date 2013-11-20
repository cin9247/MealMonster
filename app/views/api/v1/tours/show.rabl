object false

child(@tour) do
  attributes :id, :name
  child({@stations => :stations}, {object_root: false}) do
    child :customer do
      attributes :forename, :surname
      child :address do
        attributes :town, :postal_code, :street_number, :street_name
      end
    end
    child :order, object_root: false do
      child :offering do
        attributes :id
      end
    end
  end
end
