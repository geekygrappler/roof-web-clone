class LineItem < ActiveRecord::Base
    belongs_to :line_item
    belongs_to :location
    belongs_to :section
    has_many :line_items
end
