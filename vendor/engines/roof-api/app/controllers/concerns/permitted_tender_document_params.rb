module PermittedTenderDocumentParams
  def permitted_tender_document_params
    {
      document: [
        :include_vat,
        {
          sections: [
            :id,
            :name,
            {
              dimensions: []
            },
            {
              tasks: [
                :id,
                :action,
                :group,
                :display_name,
                :name,
                :quantity,
                :unit,
                :price,
                :description,
                {
                  dimensions: []
                },
                {
                  comments: [
                    {
                      account: [:id, :name]
                    },
                    :text,
                    :date,
                    :id
                  ]
                }
              ]
            },
            {
              materials: [
                :id, :name, :quantity, :price, :supplied, :description,
                {
                  comments: [
                    {
                      account: [:id, :name]
                    },
                    :text,
                    :date,
                    :id
                  ]
                }
              ]
            }
          ]
        }
      ]
    }
  end
end
