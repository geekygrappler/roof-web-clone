class MaterialsReset < ActiveRecord::Migration
  def change
    BuildingMaterial.reset_master
  end
end
