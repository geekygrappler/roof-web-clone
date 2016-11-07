module Statistics
  module LastRate
    extend ActiveSupport::Concern

    included do
    end

    #statable = LineItem object, referenceable = User object (normally if scoped to the user)
    #referenceable is not yet used because there is no user model
    def self.calc(opts={})
      opts[:value].to_i
    end

    def self.val(stat)
      # makes the value an integer for money operations, database stores as decimal e.g. 1000.0
      stat.value.to_i
    end
  end
end
