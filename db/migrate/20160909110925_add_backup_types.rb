class AddBackupTypes < ActiveRecord::Migration
  def change
    BackupType.create(name: 'JSON')
    BackupType.create(name: 'CSV')
    BackupType.create(name: 'PDF')
  end
end
