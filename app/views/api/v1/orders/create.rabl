object false

child @order do
  attributes :id, :note

  child :customer do
    attributes :forename, :surname
  end

  child @order.offering.menu, object_root: false do
    attribute :id, :name
    child :meals, object_root: false do
      attributes :id, :name
    end
  end
end
