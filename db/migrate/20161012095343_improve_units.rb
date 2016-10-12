class ImproveUnits < ActiveRecord::Migration
    def change
        add_column :units, :description, :string
        add_column :units, :abbreviation, :string
        add_column :units, :power, :integer
    end
end
