class Document < ActiveRecord::Base
  belongs_to :document
  belongs_to :document_state
  belongs_to :user
  has_many :documents
  has_many :sections, -> { order(created_at: :asc) }

  before_save :calculate_totals

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
