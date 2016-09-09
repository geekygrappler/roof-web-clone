class AdminSpecController < ApplicationController
  before_action :redirect_to_home
  def specs
    @architects = Architect.all
  end

  def document
    @document = Document.find(params[:id])
    @document_invitations = @document.document_invitations
    @document_files = @document.document_uploads
    @file_bucket = ROOF_AWS_RESOURCE.bucket("document-uploads-#{Rails.env}")
    @document_backups = @document.backups
    @backup_bucket = ROOF_AWS_RESOURCE.bucket("document-backups-#{Rails.env}")
  end

  def destroy_architect
    Architect.find(params[:id]).destroy
    redirect_to admin_specs_path
  end

  def destroy_invite
    invite, id = DocumentInvitation.find(params[:id]), invite.id
    invite.destroy
    redirect_to admin_document_path(invite.document)
  end

  def send_pro_email

  end

  private

  def redirect_to_home
    redirect_to root_url unless current_account && current_account.administrator?
  end
end
