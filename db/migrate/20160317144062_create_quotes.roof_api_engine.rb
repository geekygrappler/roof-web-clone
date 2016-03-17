# This migration comes from roof_api_engine (originally 20160315150613)
class CreateQuotes < ActiveRecord::Migration
  def change
    create_table :quotes do |t|
      t.references :tender, index: true, foreign_key: true
      t.references :professional, index: true
      t.references :project, index: true, foreign_key: true
      t.jsonb :data, default: {}

      t.timestamps null: false
    end
  end
end
