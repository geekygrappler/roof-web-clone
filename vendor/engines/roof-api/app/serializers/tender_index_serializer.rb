class TenderIndexSerializer < ActiveModel::Serializer
  cache key: 'tenders', compress: true, expires_in: 3.hours
  attributes :id, :total_amount, :project_id, :tender_template_id, :created_at, :updated_at
end
