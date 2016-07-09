class TenderTemplatesController < ResourceController

  def toggle_searchable
    searchable = ActiveRecord::ConnectionAdapters::Column::TRUE_VALUES.include?(params['tender_template']['data']['searchable'])
    @record.data['searchable'] = !searchable
    @record.save
    render json: {response: @record.data['searchable']}
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
