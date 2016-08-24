class Section < ActiveRecord::Base
  belongs_to :document
  has_many :line_items
  has_many :building_materials
end
