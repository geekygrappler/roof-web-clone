class Unit < ActiveRecord::Base
  has_many :line_items
  has_many :building_materials
end
