class LeadSerializer < ActiveModel::Serializer
  cache key: 'lead', compress: true, expires_in: 3.hours
  attributes :id, :first_name, :last_name, :phone_number, :meta
end
