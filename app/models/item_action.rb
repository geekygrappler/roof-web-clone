class ItemAction < ActiveRecord::Base
    has_and_belongs_to_many :item
end