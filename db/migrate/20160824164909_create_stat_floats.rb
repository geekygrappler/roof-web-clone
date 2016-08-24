class CreateStatFloats < ActiveRecord::Migration
  def change
    create_table :stat_floats do |t|
      t.references :stat, index: true, foreign_key: true
      t.float :value

      t.timestamps null: false
    end
  end
end
