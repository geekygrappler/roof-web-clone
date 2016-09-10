class SectionSerializer < ActiveModel::Serializer
  attributes :id, :name, :notes
  has_many :line_items, serializer: LineItemSerializer
  has_many :building_materials
end
