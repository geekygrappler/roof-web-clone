class AddTotalToBuildingMaterials < ActiveRecord::Migration
  def change
    add_column :building_materials, :total, :integer
  end
end
