class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.references :line_item, index: true, foreign_key: true
      t.references :location, index: true, foreign_key: true
      t.string :name
      t.string :description
      t.integer :quantity
      t.integer :rate
      t.integer :total
      t.boolean :admin_verified

      t.timestamps null: false
    end
  end
end
