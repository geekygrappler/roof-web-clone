# This migration comes from roof_api_engine (originally 20160315140353)
class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.jsonb :data, default: {}

      t.timestamps null: false
    end
  end
end
