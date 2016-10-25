class AddActionReferenceToLineItem < ActiveRecord::Migration
    def change
        add_reference :line_items, :action, index: true, foreign_key: true
    end
end
