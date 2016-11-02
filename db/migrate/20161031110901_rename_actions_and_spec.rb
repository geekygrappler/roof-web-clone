class RenameActionsAndSpec < ActiveRecord::Migration
    def change
        rename_table :actions, :item_actions
        rename_table :specs, :item_specs
        rename_table :actions_items, :item_actions_items
        rename_column :item_actions_items, :action_id, :item_action_id
        rename_column :line_items, :action_id, :item_action_id
        rename_column :line_items, :spec_id, :item_spec_id
        remove_column :items, :spec_id
    end
end
