class CreateStatTypes < ActiveRecord::Migration
  def change
    create_table :stat_types do |t|
      t.string :name
      t.string :metric
      t.string :calculation
      t.text :description

      t.timestamps null: false
    end
  end
end
