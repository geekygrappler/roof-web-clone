class QuotesController < ResourceController
  include PermittedTenderDocumentParams

  def create
    # auto add to professionals if admin adds the quote with him
    if current_account.administrator?
      if permitted_params[:tender_id] &&
        permitted_params[:professional_id] &&
        permitted_params[:project_id] &&
        (!permitted_params[:document] || permitted_params[:document][:sections].nil?)

        @record = self.class.model.new(permitted_params)
        authorize_record!
        @record.project.add_to_professionals @record.professional
        render(@record.save ? record_response(:created) : errors_response)
      else
        super
      end
    else
      super
    end
  end

  def accept
    if @record.accept
      head :no_content
    else
      render(errors_response)
    end
  end

  def submit
    if @record.submit(permitted_params)
      head :no_content
    else
      render(errors_response)
    end
  end

  protected

  def set_records
    super
    @records = @records.where(id: params[:id]) if params[:id]
    @records = @records.where(project_id: params[:project_id]) if params[:project_id]
    @records = @records.where(professional_id: params[:professional_id]) if params[:professional_id]
    @records
  end

  def permitted_attributes
    [
      :tender_id,
      :professional_id,
      :project_id,
      :insurance_amount,
      :guarantee_length,
      :summary,
      permitted_tender_document_params
    ]
  end
end
