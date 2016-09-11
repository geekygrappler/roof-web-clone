class SpecController < ApplicationController
  def new
  end

  def create
    architect = Architect.create(name: params[:name], phone: params[:phone], email: params[:email], address_1: params[:address_1],
                     address_2: params[:address_2], city: params[:city], postcode: params[:postcode])
    document = Document.create_default_document(architect)
    redirect_to document_path(document)
  end

  def invite
    @document = Document.find(params[:document_id])
    @architect = @document.architect
  end

  def create_invites
    document = Document.find(params[:document_id])
    inform_admin()
    invite_users(document)
    write_csv(document)
    upload_documents(params[:plans], document.id) if params[:plans].present?
    redirect_to thanks_spec_path
  end

  def thanks
  end

  private

  def document_params
    params.require(:document).permit(invites: [:name, :email, :phone])
  end

  def inform_admin

  end

  def invite_users(document)
    document.update(document_invitations_attributes: document_params[:invites].map(&:last))
  end

  def write_csv(document)
    Backup.create_csv_backup(document)
  end

  def upload_documents(docs, document_id)
    s3 = Aws::S3::Resource.new
    bucket = s3.bucket("document-uploads-#{Rails.env}")

    docs.each do |key, value|
      next if value['url'].blank?
      d = DocumentUpload.create(document_id: document_id)
      file_name = "document-#{d.id}.pdf"
      save_path = Rails.root.join('tmp', file_name)
      file = File.new(save_path, 'w+:ASCII-8BIT')
      file.write(value['url'].read)
      file.close
      obj = bucket.object(file_name)
      obj.upload_file(save_path)
      d.s3_url = obj.key
      d.save
    end
  end
end
