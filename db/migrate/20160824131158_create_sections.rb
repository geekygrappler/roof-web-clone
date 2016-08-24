class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.references :document, index: true, foreign_key: true
      t.string :name
      t.text :notes
      t.integer :total_cost_line_items
      t.integer :total_cost_supplied_materials
      t.integer :total_cost_supplied_by_pro_materials
      t.integer :total_cost

      t.timestamps null: false
    end
  end
end
