class CreateBuildingMaterials < ActiveRecord::Migration
  def change
    create_table :building_materials do |t|
      t.string :name
      t.integer :price
      t.references :building_material, index: true, foreign_key: true
      t.references :section, index: true, foreign_key: true
      t.references :location, index: true, foreign_key: true
      t.boolean :supplied

      t.timestamps null: false
    end
  end
end
