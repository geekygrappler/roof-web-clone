class QuoteProfessionalSerializer < ActiveModel::Serializer
  cache key: 'quote_professional', compress: true, expires_in: 3.hours
  attributes :id, :profile, :address
end
