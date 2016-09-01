class SectionSerializer < ActiveModel::Serializer
  attributes :id, :name, :notes, :line_items
  has_many :line_items
end
