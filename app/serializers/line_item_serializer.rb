class LineItemSerializer < ActiveModel::Serializer
    attributes :id, :name, :description, :quantity, :rate, :total, :admin_verified, :location
    def location
        "Hello"
    end
end
