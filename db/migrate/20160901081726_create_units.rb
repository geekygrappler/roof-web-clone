class CreateUnits < ActiveRecord::Migration
  def change
    create_table :units do |t|
      t.string :name

      t.timestamps null: false
    end
    add_reference :line_items, :unit
  end
end
