class ItemSearchSerializer < ActiveModel::Serializer
    attributes :id, :name
    self.root = false
end
