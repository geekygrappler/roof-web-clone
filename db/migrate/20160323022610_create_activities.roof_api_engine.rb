# This migration comes from roof_api_engine (originally 20160323022140)
class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.references :actor, polymorphic: true, index: true
      t.references :subject, polymorphic: true, index: true
      t.jsonb :data, default: {}

      t.timestamps null: false
    end
  end
end
