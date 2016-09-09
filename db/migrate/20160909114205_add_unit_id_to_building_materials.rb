class AddUnitIdToBuildingMaterials < ActiveRecord::Migration
  def change
    add_reference :building_materials, :unit, index: true, foreign_key: true
  end
end
