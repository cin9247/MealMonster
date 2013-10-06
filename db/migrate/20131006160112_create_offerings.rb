class CreateOfferings < ActiveRecord::Migration
  def change
    create_table :offerings do |t|
      t.date :date, null: false
      t.integer :menu_id, null: false
    end
  end
end
