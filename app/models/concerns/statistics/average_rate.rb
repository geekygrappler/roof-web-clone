module Statistics
  module AverageRate
    extend ActiveSupport::Concern

    included do
    end

    def self.calc(opts={})
      #referenceable is not yet used because there is no user model
      statable = opts[:statable]
      line_items = LineItem.where(
          location_id: statable.location_id,
          item_action_id: statable.item_action_id,
          item_spec_id: statable.item_spec_id
      )
      line_items.average(:rate).to_i
    end

    def self.val(stat)
      # makes the value an integer for money operations, database stores as decimal e.g. 1000.0
      stat.value.to_i
    end
  end
end