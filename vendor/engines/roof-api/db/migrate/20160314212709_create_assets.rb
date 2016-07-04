class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.references :project, index: true, foreign_key: true
      t.string :file
      t.integer :file_size
      t.string :content_type, index: true

      t.timestamps null: false
    end
  end
end
