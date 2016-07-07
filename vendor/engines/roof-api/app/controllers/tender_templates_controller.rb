class TenderTemplatesController < ResourceController

  def toggle_searchable
    searchable = params['tender_template']['data']['searchable']
    @record.data['searchable'] = searchable == 'true'
    @record.save
    render json: {response: true}
  end

  include PermittedTenderDocumentParams

  protected

  def permitted_attributes
    [
      :name,
      {data: [:searchable]},
      permitted_tender_document_params
    ]
  end
end
