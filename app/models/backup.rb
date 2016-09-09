class Backup < ActiveRecord::Base
  belongs_to :document
  belongs_to :backup_type

  def self.create_csv_backup(document)
    backup = create(document_id: document.id, backup_type_id: BackupType.where(name: 'CSV').first.id)
    bucket = ROOF_AWS_RESOURCE.bucket("document-backups-#{Rails.env}")
    file_name = "csv-#{backup.id}.csv"
    save_path = Rails.root.join('tmp', file_name)
    document.create_csv_file(save_path)
    obj = bucket.object(file_name)
    obj.upload_file(save_path)
    backup.s3_url = obj.key
    backup.save
  end

  def create_pdf_backup(document)

  end

  def create_json_backup(document)

  end
end
