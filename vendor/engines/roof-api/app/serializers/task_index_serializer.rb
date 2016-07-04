class TaskIndexSerializer < ActiveModel::Serializer
  cache key: 'tasks', compress: true, expires_in: 3.hours
  attributes :id, :action, :group, :name, :quantity, :unit, :price, :searchable, :tags, :created_at, :updated_at
  def quantity
    object.quantity.to_i
  end
  def price
    object.price.to_i
  end
end
