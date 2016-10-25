class DropActionColumnFromItem < ActiveRecord::Migration
    def change
        remove_column :items, :action_id
    end
end
