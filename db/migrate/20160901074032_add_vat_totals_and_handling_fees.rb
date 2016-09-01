class AddVatTotalsAndHandlingFees < ActiveRecord::Migration
  def change
    add_column :sections, :total_pro_costs, :integer
    add_column :documents, :total_pro_costs, :integer
    remove_column :documents, :vat
    add_column :documents, :vat_amount, :integer
    add_column :documents, :handling_fee_amount, :integer
  end
end
