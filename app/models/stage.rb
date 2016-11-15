class Stage < ActiveRecord::Base
    belongs_to :document
    has_many :line_items, -> { order(created_at: :asc) }

    before_save :calculate_totals
    after_save :calculate_document_totals

    private

    def calculate_totals
        self.total_cost = line_items.map { |s| s.total.to_i }.sum
    end

    def calculate_document_totals
        # triggers document.calculate_totals
        document.save unless document.nil?
    end
end
