class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.references :document, index: true, foreign_key: true
      t.references :document_state, index: true, foreign_key: true
      t.string :name
      t.references :user, index: true, foreign_key: true
      t.integer :total_cost_line_items
      t.integer :total_cost_supplied_materials
      t.integer :total_cost_supplied_by_pro_materials
      t.integer :total_cost
      t.boolean :vat
      t.text :notes

      t.timestamps null: false
    end
  end
end
