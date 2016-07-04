class CreateTenderTemplates < ActiveRecord::Migration
  def change
    create_table :tender_templates do |t|
      t.jsonb :data, default: {}

      t.timestamps null: false
    end
  end
end
