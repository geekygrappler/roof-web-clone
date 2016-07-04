class ProjectIndexSerializer < ActiveModel::Serializer
  cache key: 'projects', compress: true, expires_in: 3.hours

  attributes :id, :name, :kind, :account_id, :created_at, :updated_at, :customers_ids, :professionals_ids, :administrators_ids

  # has_one :tender
  # has_many :assets

  has_many :customers, serializer: AccountIndexSerializer
  has_many :professionals, serializer: AccountIndexSerializer
  has_many :administrators, serializer: AccountIndexSerializer

  def professionals
    if scope.professional?
      object.professionals.where(id: scope.id)
    else
      object.professionals
    end
  end


end
