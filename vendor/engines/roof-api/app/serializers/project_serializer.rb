class ProjectSerializer < ActiveModel::Serializer
  cache key: 'project', compress: true, expires_in: 3.hours
  attributes :id, :name, :kind, :brief, :address, :account_id, :customers_ids, :professionals_ids, :administrators_ids

  has_one :tender, serializer: TenderSerializer
  has_many :assets
  has_many :customers, serializer: AccountSerializer
  has_many :professionals, serializer: AccountSerializer
  has_many :administrators, serializer: AccountSerializer

end
