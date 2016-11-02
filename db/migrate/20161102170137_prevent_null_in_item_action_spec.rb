class PreventNullInItemActionSpec < ActiveRecord::Migration
    def up
        change_column :items, :name, :string, null: false
        change_column :item_actions, :name, :string, null: false
        change_column :item_specs, :name, :string, null: false
    end

    def down
        change_column :items, :name, :string, null: true
        change_column :item_actions, :name, :string, null: true
        change_column :item_specs, :name, :string, null: true
    end
end
