class LineItem < ActiveRecord::Base
    include PgSearch
    include TaskCsvReset
    belongs_to :line_item
    belongs_to :location
    belongs_to :section
    belongs_to :action
    belongs_to :spec
    has_many :line_items

    delegate :name, to: :unit, prefix: true, allow_nil: true
    delegate :name, to: :location, prefix: true, allow_nil: true

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
end
