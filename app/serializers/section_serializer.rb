class SectionSerializer < ActiveModel::Serializer
  attributes :id, :name, :notes, :line_items, :building_materials
  has_many :line_items
  has_many :building_materials
end
