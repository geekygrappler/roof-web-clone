class AddDescriptionToBuildingMaterials < ActiveRecord::Migration
  def change
    add_column :building_materials, :description, :text
  end
end
