class LeadIndexSerializer < ActiveModel::Serializer
  cache key: 'leads', compress: true, expires_in: 3.hours
  attributes :id, :converted, :first_name, :last_name, :phone_number, :created_at, :updated_at
end
