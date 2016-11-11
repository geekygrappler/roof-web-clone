class Location < ActiveRecord::Base
    belongs_to :document
    has_many :line_items, -> { order(created_at: :asc) }
end
