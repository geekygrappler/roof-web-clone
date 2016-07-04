class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :account, index: true, foreign_key: true
      t.references :commentable, polymorphic: true, index: true
      t.jsonb :data, default: {}

      t.timestamps null: false
    end
  end
end
