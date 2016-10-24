class AddItemActionSpecRelations < ActiveRecord::Migration
    def change
        add_reference :items, :action, index: true, foreign_key: true
        add_reference :specs, :item, index: true, foreign_key: true
    end
end
