require 'csv'
class Document < ActiveRecord::Base
    include CsvBackup
    belongs_to :document
    belongs_to :document_state
    belongs_to :architect
    has_many :documents, dependent: :destroy
    has_many :sections, -> { order(created_at: :asc) }, dependent: :destroy
    has_many :backups, dependent: :destroy
    has_many :document_invitations, dependent: :destroy
    has_many :document_uploads, dependent: :destroy
    accepts_nested_attributes_for :document_invitations, reject_if: proc { |attr| attr['name'].blank? && attr['email'].blank? && attr['phone'].blank? }

    before_save :calculate_totals

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

    def calculate_totals
        self.total_cost_line_items = sections.map { |s| s.total_cost_line_items.to_i }.sum
        self.total_cost_supplied_materials = sections.map { |s| s.total_cost_supplied_materials.to_i }.sum
        self.total_cost_supplied_by_pro_materials = sections.map { |s| s.total_cost_supplied_by_pro_materials.to_i }.sum
        self.total_pro_costs = calculate_total_pro_costs
        self.total_cost = calculate_total
    end

    def calculate_total_pro_costs
        [total_cost_line_items, total_cost_supplied_by_pro_materials].sum
    end

    def calculate_total
        [total_cost_line_items, total_cost_supplied_materials, total_cost_supplied_by_pro_materials].sum
    end
end
