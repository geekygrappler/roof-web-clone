class CreateStatIntegers < ActiveRecord::Migration
  def change
    create_table :stat_integers do |t|
      t.references :stat, index: true, foreign_key: true
      t.integer :value

      t.timestamps null: false
    end
  end
end
