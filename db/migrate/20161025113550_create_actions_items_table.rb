class CreateActionsItemsTable < ActiveRecord::Migration
    def change
        create_table :actions_items, id: false do |t|
            t.belongs_to :action, index: true
            t.belongs_to :item, index: true
        end
    end
end
