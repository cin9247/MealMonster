class CreateMealsMenus < ActiveRecord::Migration
  def change
    create_table :meals_menus do |t|
      t.integer :menu_id, null: false
      t.integer :meal_id, null: false
      t.integer :position, null: false
    end
  end
end
