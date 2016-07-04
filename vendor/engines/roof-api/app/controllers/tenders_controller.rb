class TendersController < ResourceController

  include PermittedTenderDocumentParams

  def create
    if permitted_params[:project_id] &&
      permitted_params[:tender_template_id] &&
      !permitted_params[:document]

      @record = self.class.model.find_or_initialize_by(project_id: permitted_params[:project_id])
      @record.merge = true
      @record.tender_template_id = permitted_params[:tender_template_id]
      authorize_record!
      render(@record.save ? record_response(:created) : errors_response)
    else
      super
    end
  end

  protected

  def set_records
    @records = super
    @records = @records.where(project_id: params[:project_id]) if params[:project_id]
    @records
  end

  def permitted_attributes
    [
      :tender_template_id,
      :project_id,
      permitted_tender_document_params
    ]
  end
end
