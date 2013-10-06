Sequel.migration do
  change do

    create_table :menus do
      primary_key :id
    end

  end
end
