class LineItemSerializer < ActiveModel::Serializer
    attributes :id, :name, :description, :quantity, :rate, :total, :admin_verified, :action_id
    has_one :unit

    def location
        object.location_name
    end

    def rate
        Money.new(object.rate, "GBP").format
    end

    def material_cost
        # Return 2 decimal place float of the cost.
        '%.2f' % Money.new(object.material_cost, "GBP")
    end

    def total
        Money.new(object.total, "GBP").format
    end

    def action_id
        if object.action then object.action.id end
    end
end
