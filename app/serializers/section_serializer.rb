class SectionSerializer < ActiveModel::Serializer
  attributes :id, :name, :notes
  has_many :line_items
end
