class CreateMenu < ActiveRecord::Migration
  def change
    create_table :menus do |t|
      t.date :date, null: false
    end
  end
end
