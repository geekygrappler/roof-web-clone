class LineItemSerializer < ActiveModel::Serializer
    attributes :id, :name, :description, :quantity, :rate, :total, :admin_verified
    has_one :item_action
    has_one :item_spec
    has_one :location
    has_one :stage

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
