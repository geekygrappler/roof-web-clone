class AccountIndexSerializer < ActiveModel::Serializer
  cache key: 'accounts', compress: true, expires_in: 3.hours
  attributes :id, :email, :full_name, :user_id, :user_type, :created_at, :updated_at

  def full_name
    "#{object.user.profile.first_name} #{object.user.profile.last_name}"
  end
end
