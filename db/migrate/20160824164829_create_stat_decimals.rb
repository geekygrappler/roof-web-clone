class CreateStatDecimals < ActiveRecord::Migration
  def change
    create_table :stat_decimals do |t|
      t.references :stat, index: true, foreign_key: true
      t.decimal :value

      t.timestamps null: false
    end
  end
end
