class TenderTemplatesController < ResourceController

  include PermittedTenderDocumentParams

  protected

  def permitted_attributes
    [
      :name,
      permitted_tender_document_params
    ]
  end
end
