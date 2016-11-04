class Rate < ActiveRecord::Base
    validates :rate, presence: true
    belongs_to :item
    belongs_to :item_spec
    belongs_to :item_action

    validates_associated :item

    before_save :format_rate

    private
    def format_rate
        self.formatted_rate = Money.new(self.rate, :GBP).format
    end
end
