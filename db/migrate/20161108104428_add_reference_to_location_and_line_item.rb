class AddReferenceToLocationAndLineItem < ActiveRecord::Migration
    def change
        add_reference :locations, :document, index: true, foreign_key: true
    end
end
