class AdministratorSerializer < ActiveModel::Serializer
  cache key: 'administrator', compress: true, expires_in: 3.hours
  attributes :id, :profile, :notifications, :account_id
end
