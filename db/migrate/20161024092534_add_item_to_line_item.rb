class AddItemToLineItem < ActiveRecord::Migration
    def change
        add_reference :line_items, :item, index: true, foreign_key: true
    end
end
