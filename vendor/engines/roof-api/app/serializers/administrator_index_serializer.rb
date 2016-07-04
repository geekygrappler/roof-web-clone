class AdministratorIndexSerializer < ActiveModel::Serializer
  cache key: 'administrators', compress: true, expires_in: 3.hours
  attributes :id, :account_id, :full_name, :first_name, :last_name, :phone_number, :created_at, :updated_at
  def full_name
    "#{object.profile.first_name} #{object.profile.last_name}"
  end
  def first_name
    object.profile.first_name
  end
  def last_name
    object.profile.last_name
  end
  def phone_number
    object.profile.phone_number
  end
end
