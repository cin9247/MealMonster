object false

child @order do
  attributes :id, :customer_id

  child :customer do
    attributes :forename, :lastname
  end

  child @order.offering.menu, object_root: false do
    attribute :id, :name
    child :meals, object_root: false do
      attributes :id, :name
    end
  end
end
