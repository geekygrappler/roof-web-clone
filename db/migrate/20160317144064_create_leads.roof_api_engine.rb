# This migration comes from roof_api_engine (originally 20160317075032)
class CreateLeads < ActiveRecord::Migration
  def change
    create_table :leads do |t|
      t.jsonb :data

      t.timestamps null: false
    end
  end
end
