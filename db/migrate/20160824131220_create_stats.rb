class CreateStats < ActiveRecord::Migration
  def change
    create_table :stats do |t|
      t.references :enumerable, polymorphic: true, index: true
      t.references :stat_type, index: true, foreign_key: true
      t.references :statable, polymorphic: true, index: true
      t.references :referenceable, polymorphic: true, index: true
      t.timestamps null: false
    end
  end
end
