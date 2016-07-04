class CreateTenders < ActiveRecord::Migration
  def change
    create_table :tenders do |t|
      t.references :tender_template, index: true, foreign_key: true
      t.references :project, index: true, foreign_key: true
      t.jsonb :data, default: {}

      t.timestamps null: false
    end
  end
end
