class CustomerSerializer < ActiveModel::Serializer
  cache key: 'customer', compress: true, expires_in: 3.hours
  attributes :id, :profile, :notifications, :account_id
end
