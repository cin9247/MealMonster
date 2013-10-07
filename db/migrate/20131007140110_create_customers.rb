Sequel.migration do
  change do
    create_table :customers do
      primary_key :id
      String :forename
      String :surname
    end
  end
end
