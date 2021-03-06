object false

child(@tour) do
  attributes :id, :name
  child({@stations => :stations}, {object_root: false}) do
    child :customer do
      attributes :id
      attributes :forename, :surname, :prefix, :note, :telephone_number
      child :address do
        attributes :town, :postal_code, :street_number, :street_name
      end
    end
    child :order, object_root: false do
      attributes :id
      child :offerings, object_root: false do
        attributes :id, :name
        child :meals, object_root: false do
          attributes :id, :name
        end
      end
      attributes :delivered
      attributes :loaded
    end
  end
end
