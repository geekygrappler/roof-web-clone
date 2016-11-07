class RemoveCalculationFromStatTypes < ActiveRecord::Migration
  def change
    remove_column :stat_types, :calculation
  end
end
