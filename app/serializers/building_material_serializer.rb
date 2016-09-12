class BuildingMaterialSerializer < ActiveModel::Serializer
  attributes :id, :total, :price

  def convert_totals(data)
    totals = [:total, :price]

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
