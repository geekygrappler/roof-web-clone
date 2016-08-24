class BuildingMaterial < ActiveRecord::Base
  belongs_to :building_material
  belongs_to :section
  belongs_to :location
  has_many :building_materials
end
