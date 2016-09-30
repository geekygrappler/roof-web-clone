class AddMaterialCostToLineItems < ActiveRecord::Migration
    def change
        add_column :line_items, :material_cost, :integer
    end
end
