class CreateBackupTypes < ActiveRecord::Migration
  def change
    create_table :backup_types do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
