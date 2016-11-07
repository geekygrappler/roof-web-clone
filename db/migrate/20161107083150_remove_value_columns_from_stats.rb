class RemoveValueColumnsFromStats < ActiveRecord::Migration
  def up
    drop_table :stat_decimals
    drop_table :stat_integers
    drop_table :stat_floats
    add_column :stats, :value, :decimal
  end

  def down
    create_table :stat_decimals do |t|
      t.references :stat, index: true, foreign_key: true
      t.decimal :value
      t.timestamps null: false
    end
    create_table :stat_integers do |t|
      t.references :stat, index: true, foreign_key: true
      t.integer :value
      t.timestamps null: false
    end
    create_table :stat_floats do |t|
      t.references :stat, index: true, foreign_key: true
      t.float :value
      t.timestamps null: false
    end
    remove_column :stats, :value, :decimal
  end
end
