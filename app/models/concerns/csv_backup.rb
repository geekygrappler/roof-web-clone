module CsvBackup
  extend ActiveSupport::Concern

  included do
  end

  def create_csv_file(path)
    file = CSV.open(path, 'w' ) do |csv|
      csv << ['Tender:', self.name, self.notes]
      csv << ['Headers:', 'total_cost_line_items', 'total_cost_supplied_materials', 'total_cost_supplied_by_pro_materials',
              'total_pro_costs', 'total_cost', 'handling_fee_amount', 'For Administation use']

      csv << ['', self.total_cost_line_items, self.total_cost_supplied_materials,
              self.total_cost_supplied_by_pro_materials, self.total_pro_costs, self.total_cost,
              self.handling_fee_amount, get_csv_reference_by_obj(self)]

      self.sections.each do |section|
        csv << ['']
        csv << ['']
        csv << ['Section:', section.name, section.notes]
        csv << ['Headers: ', 'total_cost_line_items', 'total_cost_supplied_materials', 'total_cost_supplied_by_pro_materials',
                'total_pro_costs', 'total_cost', 'For Administation use']

        csv << ['', section.total_cost_line_items, section.total_cost_supplied_materials,
                section.total_cost_supplied_by_pro_materials, section.total_pro_costs, section.total_cost,
                get_csv_reference_by_obj(section)]

        csv << ['']
        csv << ['Line Items']
        csv << ['Headers: ', 'Name', 'Description', 'Quantity', 'Rate', 'Total', 'Unit', 'Location', 'For Administation use']
        section.line_items.each do |line_item|
          csv << ['', line_item.name, line_item.description, line_item.quantity, line_item.rate, line_item.total,
                  line_item.unit_name, line_item.location_name, get_csv_reference_by_obj(line_item)]
        end
        csv << ['']
        csv << ['Materials']
        csv << ['Headers:', 'name', 'description', 'price', 'total', 'unit', 'supplied', 'location', 'For Administation use']
        section.building_materials.each do |building_material|
          csv << ['', building_material.name, building_material.description, building_material.price, building_material.total,
                  building_material.unit_name, building_material.supplied, building_material.location_name,
                  get_csv_reference_by_obj(building_material)]
        end
      end
      csv << ['']
    end
    return file
  end

  private

  def get_csv_reference_by_obj(obj)
    CsvReference.where(database_objectable_id: obj.id, database_objectable_type: obj.class.name).first_or_create.key
  end

  def get_csv_reference_by_key(obj)
    CsvReference.where(key).first
  end

end