class RemoveDateFromMenus < ActiveRecord::Migration
  def up
    remove_column :menus, :date
  end

  def down
    add_column :menus, :date, :date, null: false
  end
end
