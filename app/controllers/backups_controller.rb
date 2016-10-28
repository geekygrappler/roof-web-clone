class BackupsController < ApplicationController
  def create
    document = Document.find(params[:id])
    backup = case params[:type]
               when 'CSV' then Backup.create_csv_backup(document)
               when 'PDF' then Backup.create_pdf_backup(document)
               else
                 Backup.create_csv_backup(document)
             end
    bucket = ROOF_AWS_RESOURCE.bucket("document-backups-#{Rails.env}")

    render json: {url: bucket.object(backup.s3_url).presigned_url(:get, expires_in: 3600)}
  end
end
