class Section < ActiveRecord::Base
  belongs_to :document
  has_many :line_items, -> { order(created_at: :asc) }
  has_many :building_materials
  has_many :supplied_materials, -> { where(supplied: true) }, through: :building_materials, source: :building_materials
  has_many :materials_supplied_by_pro, -> { where(supplied: false) }, through: :building_materials, source: :building_materials
  validates_presence_of :document

  before_save :calculate_totals
  after_save :calculate_document_totals

  private

  def calculate_totals
    self.total_cost_line_items = line_items.map { |s| s.total.to_i }.sum
    self.total_cost_supplied_materials = supplied_materials.map { |s| s.total.to_i }.sum
    self.total_cost_supplied_by_pro_materials = materials_supplied_by_pro.map { |s| s.total.to_i }.sum
    self.total_pro_costs = calculate_total_pro_costs
    self.total_cost = calculate_total
  end

  def calculate_total_pro_costs
    [total_cost_line_items, total_cost_supplied_by_pro_materials].sum
  end

  def calculate_total
    [total_cost_line_items, total_cost_supplied_materials, total_cost_supplied_by_pro_materials].sum
  end

  def calculate_document_totals
    # triggers document.calculate_totals
    document.save unless document.nil?
  end

end
