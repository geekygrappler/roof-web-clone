class CreateBackups < ActiveRecord::Migration
  def change
    create_table :backups do |t|
      t.string :s3_url
      t.references :document, index: true, foreign_key: true
      t.references :backup_type, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
