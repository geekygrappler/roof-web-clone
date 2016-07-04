class TaskSerializer < ActiveModel::Serializer
  #cache key: 'task', compress: true, expires_in: 3.hours
  attributes :id, :action, :group, :name, :quantity, :unit, :price, :searchable, :tags
  def quantity
    object.quantity.to_i
  end
  def price
    object.price.to_i
  end
end
