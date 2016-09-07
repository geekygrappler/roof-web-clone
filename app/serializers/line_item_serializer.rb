class LineItemSerializer < ActiveModel::Serializer
    attributes :id

    def location
        byebug
        "Hello"
    end
end
