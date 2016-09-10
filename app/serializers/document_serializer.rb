class DocumentSerializer < ActiveModel::Serializer
  attributes :id, :name, :total_cost_line_items, :total_cost_supplied_materials, :total_cost_supplied_by_pro_materials, :total_cost, :notes
  has_one :document
  has_one :document_state
  has_one :architect
  has_many :sections
  has_many :sections, serializer: SectionSerializer

  def convert_totals(data)
      totals = [:total_cost, :total_cost_line_items, :total_cost_supplied_materials, :total_cost_supplied_by_pro_materials]

      totals.each do |total|
          data[total] = Money.new(object[total], "GBP").format
      end
  end

  def attributes(*args)
      data = super
      convert_totals(data)
      data
  end
end
