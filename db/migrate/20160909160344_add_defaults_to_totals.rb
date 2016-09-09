class AddDefaultsToTotals < ActiveRecord::Migration
  def change
    change_column_default :documents, :total_cost_line_items, 0
    change_column_default :documents, :total_cost_supplied_materials, 0
    change_column_default :documents, :total_cost_supplied_by_pro_materials, 0
    change_column_default :documents, :total_pro_costs, 0
    change_column_default :documents, :total_cost, 0

    change_column_default :sections, :total_cost_line_items, 0
    change_column_default :sections, :total_cost_supplied_materials, 0
    change_column_default :sections, :total_cost_supplied_by_pro_materials, 0
    change_column_default :sections, :total_pro_costs, 0
    change_column_default :sections, :total_cost, 0

    change_column_default :line_items, :quantity, 0
    change_column_default :line_items, :rate, 0
    change_column_default :line_items, :total, 0

    change_column_default :building_materials, :price, 0
    change_column_default :building_materials, :total, 0

  end
end
