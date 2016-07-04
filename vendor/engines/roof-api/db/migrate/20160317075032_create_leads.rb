class CreateLeads < ActiveRecord::Migration
  def change
    create_table :leads do |t|
      t.jsonb :data, default: {}

      t.timestamps null: false
    end
  end
end
