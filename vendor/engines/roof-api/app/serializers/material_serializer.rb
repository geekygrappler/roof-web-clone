class MaterialSerializer < ActiveModel::Serializer
  cache key: 'material', compress: true, expires_in: 3.hours
  attributes :id, :name, :quantity, :price, :supplied, :searchable, :tags
  def quantity
    object.quantity.to_i
  end
  def price
    object.price.to_i
  end
end
