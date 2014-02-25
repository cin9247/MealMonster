object false

child @user do
  attributes :id, :name
  if @user.customer
    child :customer do
      attributes :id, :forename, :surname
      child :address do
        attributes :town, :street_name, :street_number, :postal_code
      end
    end
  end
end
