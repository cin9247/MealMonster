object false

child @user do
  attributes :id, :name
  if @user.customer
    child :customer do
      attributes :id, :forename, :surname
    end
  end
end
