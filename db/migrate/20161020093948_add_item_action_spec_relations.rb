class AddItemActionSpecRelations < ActiveRecord::Migration
    def change
        create_table :actions_items, id: false do |t|
            t.belongs_to :item, index: true
            t.belongs_to :action, index: true
        end
        add_reference :specs, :item, index: true, foreign_key: true
    end
end
