class Item < ActiveRecord::Base
    has_and_belongs_to_many :action
    has_many :spec
end
