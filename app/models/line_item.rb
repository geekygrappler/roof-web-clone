class LineItem < ActiveRecord::Base
    include PgSearch
    include TaskCsvReset
    belongs_to :location
    belongs_to :document
    belongs_to :item_action
    belongs_to :item_spec
    belongs_to :section

    after_initialize :set_defaults
    after_save :calculate_section_totals

    pg_search_scope :full_text_search,
        :against => :name,
        :using => {
            :tsearch => {
                :any_word => true,
                :dictionary => 'english',
                :prefix => true,
                :highlight => true
            }
        }

    private

    def calculate_section_totals
        # triggers section.calculate_totals
        section.save unless section.nil?
    end

    def calculate_total
        self.total = rate.to_i * quantity.to_i
    end

    # Set default values for Item
    def set_defaults
        item = Item.find_or_create_by(name: self.name)
        if self.item_action.nil?
            self.item_action = item.item_actions.first
        end
        if self.item_spec.nil?
            self.item_spec = item.item_specs.first
        end
        if self.rate == 0
            self.rate = default_rate(item)
        end
    end

    # Finds default rate for a newly created LineItem
    #
    # @param [Item] the Item associated to the LineItem
    # @return [Rate] the Rate for the LineItem
    def default_rate(item)
        rate = Rate.where(
           item: item,
           item_action: self.item_action,
           item_spec: self.item_spec
        )
        if !rate.empty?
            return rate.first.rate
        end
    end
end
