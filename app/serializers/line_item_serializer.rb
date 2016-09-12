class LineItemSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :quantity, :rate, :total, :admin_verified, :location

  def location
    object.location_name
  end

  def rate
    Money.new(object.rate, "GBP").format
  end

  def total
    Money.new(object.total, "GBP").format
  end
end
