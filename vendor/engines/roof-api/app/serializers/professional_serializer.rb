class ProfessionalSerializer < ActiveModel::Serializer
  cache key: 'professional', compress: true, expires_in: 3.hours
  attributes :id, :profile, :stripe_account, :notifications, :account_id
  def stripe_account
    if scope.professional?
      {id: object.stripe_account.id, object: object.stripe_account.object}
    end
  end
end
