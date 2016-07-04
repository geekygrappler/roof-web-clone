class TenderTemplateSerializer < ActiveModel::Serializer
  #cache key: 'tender_template', compress: true, expires_in: 3.hours
  attributes :id, :name, :document, :total_amount
end
