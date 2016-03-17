# This migration comes from roof_api_engine (originally 20160316065334)
class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.references :project, index: true, foreign_key: true
      t.references :professional, index: true
      t.references :quote, index: true, foreign_key: true
      t.references :customer, index: true
      t.jsonb :data, default: {}

      t.timestamps null: false
    end
  end
end
