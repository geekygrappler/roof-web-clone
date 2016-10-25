class AddSpecReferenceToLineItem < ActiveRecord::Migration
    def change
        add_reference :line_items, :spec, index: true, foreign_key: true
    end
end
