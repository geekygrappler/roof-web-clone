class Rate < ActiveRecord::Base
    validates :rate, presence: true
    belongs_to :item
    belongs_to :item_spec
    belongs_to :item_action

    validates_associated :item

    before_save :format_rate

    def rate=(rate)
        if rate.is_a?(String)
            super(sanitize_rate(rate))
        else
            super(rate)
        end
    end

    private
    def format_rate
        self.formatted_rate = Money.new(self.rate, :GBP).format
    end

    def sanitize_rate(rate)
        Monetize.parse(rate, :GBP).cents
    end
end
