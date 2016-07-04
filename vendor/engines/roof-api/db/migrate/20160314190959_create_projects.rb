class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.references :account, index: true, foreign_key: true
      t.jsonb :data, default: {}

      t.timestamps null: false
    end
  end
end
