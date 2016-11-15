require 'csv'
class Document < ActiveRecord::Base
    include CsvBackup
    belongs_to :document_state
    has_many :stages, -> { order(created_at: :asc) }
    has_many :locations, -> { order(created_at: :asc) }
    has_many :backups, dependent: :destroy
    has_many :document_invitations, dependent: :destroy
    has_many :document_uploads, dependent: :destroy
    has_many :line_items
    accepts_nested_attributes_for :document_invitations, reject_if: proc { |attr| attr['name'].blank? && attr['email'].blank? && attr['phone'].blank? }

    def self.create_default_document(architect)
        default_sections = ["Preliminary", "Plumbing", "Electrics", "Carpentry", "Decorating", "Flooring", "General"]
        document = Document.create(
            name: architect.address_1 || "Name your project...",
            architect_id: architect.id || nil
        )
        default_sections.each do |section|
            document.sections.create(name: section)
        end
        return document
    end

    private

    # def calculate_totals
    #     self.total_cost = sections.map { |s| s.total_cost.to_i }.sum
    # end
end
