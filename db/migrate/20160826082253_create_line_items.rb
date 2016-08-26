class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.string :name
      t.string :specification
      t.integer :quantity
      t.integer :rate
      t.integer :total
      t.boolean :admin_verified

      t.timestamps null: false
    end
  end
end
