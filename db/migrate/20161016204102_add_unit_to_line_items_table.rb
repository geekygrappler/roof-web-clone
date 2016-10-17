class AddUnitToLineItemsTable < ActiveRecord::Migration
    def change
        add_column :line_items, :unit, :string
    end
end
