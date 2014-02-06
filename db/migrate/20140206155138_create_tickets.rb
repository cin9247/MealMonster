Sequel.migration do
  change do
    create_table :tickets do
      primary_key :id
      String :title, null: false
      String :body, null: false
    end
  end
end
