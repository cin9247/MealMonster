Sequel.migration do
  change do

    create_table :meals_menus do
      primary_key :id
      Fixnum :menu_id, null: false
      Fixnum :meal_id, null: false
      Fixnum :position, null: false
    end

  end
end
