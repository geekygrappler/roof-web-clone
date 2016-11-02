class AddUniqueIndexToItemSpecAction < ActiveRecord::Migration
    def change
        add_index :items, :name, unique: true
        add_index :item_actions, :name, unique: true
        add_index :item_specs, [:name, :item_id], unique: true
        add_index :item_actions_items, [:item_action_id, :item_id], unique: true
    end
end
