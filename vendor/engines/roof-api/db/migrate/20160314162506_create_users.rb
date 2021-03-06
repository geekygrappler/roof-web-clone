class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.references :account, index: true, foreign_key: true
      t.string :type
      t.jsonb :data, default: {}

      t.timestamps null: false
    end
    add_index :users, [:id, :type], unique: true
  end
end
