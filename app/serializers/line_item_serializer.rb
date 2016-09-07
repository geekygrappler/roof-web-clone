class LineItemSerializer < ActiveModel::Serializer
    attributes :id, :name, :description, :quantity, :rate, :total, :admin_verified, :location_id, :location

    def location
        object.location
    end
end
