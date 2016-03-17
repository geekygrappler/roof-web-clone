# This migration comes from roof_api_engine (originally 20160315140359)
class CreateMaterials < ActiveRecord::Migration
  def change
    create_table :materials do |t|
      t.jsonb :data, default: {}

      t.timestamps null: false
    end
  end
end
