class StageSerializer < ActiveModel::Serializer
  attributes :id, :name, :notes, :total_cost

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
