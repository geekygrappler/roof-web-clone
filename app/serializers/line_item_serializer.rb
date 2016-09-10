class LineItemSerializer < ActiveModel::Serializer
    attributes :id, :location

    def location
        "Hello"
    end
end
