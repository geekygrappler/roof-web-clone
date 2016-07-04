class MaterialIndexSerializer < ActiveModel::Serializer
  cache key: 'materials', compress: true, expires_in: 3.hours
  attributes :id, :name, :quantity, :price, :supplied, :searchable, :tags, :created_at, :updated_at
  def quantity
    object.quantity.to_i
  end
  def price
    object.price.to_i
  end
end
