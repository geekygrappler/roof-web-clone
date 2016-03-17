# This migration comes from roof_api_engine (originally 20160315135654)
class CreateTenderTemplates < ActiveRecord::Migration
  def change
    create_table :tender_templates do |t|
      t.jsonb :data, default: {}

      t.timestamps null: false
    end
  end
end
