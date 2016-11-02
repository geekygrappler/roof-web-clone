class LineItem < ActiveRecord::Base
    include PgSearch
    include TaskCsvReset
    belongs_to :line_item
    belongs_to :location
    belongs_to :section
    belongs_to :item_action
    belongs_to :item_spec
    has_many :line_items

    delegate :name, to: :unit, prefix: true, allow_nil: true
    delegate :name, to: :location, prefix: true, allow_nil: true

    before_save :set_defaults
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

    # Set default values for item
    def set_defaults
        if self.item_action.nil?
            item = Item.where(name: self.name).last
            self.item_action = item.item_actions.first
        end
        if self.item_spec.nil?
            item = Item.where(name: self.name).last
            self.item_spec = item.item_specs.first
        end
    end
end
