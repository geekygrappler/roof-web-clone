class LineItemSerializer < ActiveModel::Serializer
  attributes :id, :name, :specification, :quantity, :rate, :total, :admin_verified
end
