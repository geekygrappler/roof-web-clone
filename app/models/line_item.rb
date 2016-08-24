class LineItem < ActiveRecord::Base
  belongs_to :line_item
  belongs_to :location
  has_many :line_items
end
