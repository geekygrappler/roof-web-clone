class TenderTemplateIndexSerializer < ActiveModel::Serializer
  cache key: 'tender_templates', compress: true, expires_in: 3.hours
  attributes :id, :name, :total_amount, :created_at, :updated_at, :searchable

  def searchable
    object.data['searchable']
  end
end
