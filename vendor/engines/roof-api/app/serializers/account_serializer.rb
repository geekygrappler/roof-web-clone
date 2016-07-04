class AccountSerializer < ActiveModel::Serializer
  cache key: 'account', compress: true, expires_in: 3.hours
  attributes :id, :email, :profile, :user_id, :user_type, :paying, :notifications
  def profile
    object.user.try(:profile)
  end
  def paying
    object.customer? && object.user.try(:stripe_customer).try(:id)
  end
  def notifications
    object.user.try(:notifications)
  end
end
