class CreateMaterials < ActiveRecord::Migration
  def change
    create_table :materials do |t|
      t.jsonb :data, default: {}

      t.timestamps null: false
    end
  end
end
