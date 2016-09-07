class BuildingMaterial < ActiveRecord::Base
    before_save :check_supplied

    belongs_to :building_material
    belongs_to :section
    belongs_to :location
    has_many :building_materials

    # If this is a tender (second conditional), then non-supplied materials
    # can't have a price
    def check_supplied
        if !self.supplied? && self.section.document.document == nil
            self.price = nil
        end
    end
end
