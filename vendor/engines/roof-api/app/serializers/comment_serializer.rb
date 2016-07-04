class CommentSerializer < ActiveModel::Serializer
  cache key: 'comment', compress: true, expires_in: 3.hours
  attributes :id, :text, :account_id
  belongs_to :account
end
