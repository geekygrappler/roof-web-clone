class Backup < ActiveRecord::Base
  belongs_to :document
  belongs_to :backup_type

  def self.create_csv_backup(document)
    initialize_resources(document)
    save_path = create_save_path('csv')
    document.create_csv_file(save_path)
    upload_to_s3(save_path)
  end

  def create_pdf_backup(document)

    initialize_resources(document)
    pdf = WickedPdf.new.pdf_from_string(view)
    save_path = create_save_path('pdf')
    pdf = document.create_pdf_file(save_path)
    file = File.new(save_path, "w+")
    file.write(pdf.force_encoding("UTF-8"))
    file.close
    upload_to_s3(save_path)
  end

  def create_json_backup(document)

  end

  private

  def initialize_resources(document)
    @backup = create(document_id: document.id, backup_type_id: BackupType.where(name: 'CSV').first_or_create.id)
    @bucket = ROOF_AWS_RESOURCE.bucket("document-backups-#{Rails.env}")
  end

  def create_save_path(format)
    @file_name = "csv-#{@backup.id}.csv"
    Rails.root.join('tmp', @file_name)
  end

  def upload_to_s3(save_path)
    obj = @bucket.object(@file_name)
    obj.upload_file(save_path)
    @backup.s3_url = obj.key
    @backup.save
    @backup
  end
end
