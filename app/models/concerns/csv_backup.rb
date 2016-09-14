module CsvBackup
  extend ActiveSupport::Concern

  included do
  end

  def create_csv_file(path)
    file = CSV.open(path, 'w' ) do |csv|
      csv << ['Tender:', self.name, self.notes]
      csv << ['Headers:', 'Total Cost Line Items', 'total_cost_supplied_materials' 'Total Cost Supplied Materials',
              'Total Cost_Supplied By Pro Materials', 'Total Pro Costs', 'Total Cost']

      csv << ['',
              format(self.total_cost_line_items),
              format(self.total_cost_supplied_materials),
              format(self.total_cost_supplied_by_pro_materials),
              format(self.total_pro_costs),
              format(self.total_cost)
      ]

      self.sections.each do |section|
        csv << ['']
        csv << ['']
        csv << ['Section:', section.name, section.notes]
        csv << ['Headers: ', 'Total Cost Line Items', 'Total Cost Supplied Materials',
                'Total Cost Supplied By Pro Materials', 'Total Pro Costs', 'Total Cost']

        csv << ['',
                format(section.total_cost_line_items),
                format(section.total_cost_supplied_materials),
                format(section.total_cost_supplied_by_pro_materials),
                format(section.total_pro_costs),
                format(section.total_cost)
        ]

        csv << ['']
        csv << ['Line Items']
        csv << ['Headers: ', 'Name', 'Description', 'Quantity', 'Rate', 'Total']
        section.line_items.each do |line_item|
          csv << ['',
                  line_item.name,
                  line_item.description,
                  line_item.quantity,
                  format(line_item.rate),
                  format(line_item.total)
          ]
        end
        csv << ['']
        csv << ['Materials']
        csv << ['Headers:', 'Name', 'Description', 'Price', 'Total']
        section.building_materials.each do |building_material|
          csv << ['',
                  building_material.name,
                  building_material.description,
                  format(building_material.price),
                  format(building_material.total)
          ]
        end
      end
      csv << ['']
    end
    return file
  end

  private

  def format(num)
    Money.new(num, 'GBP').format
  end

  def get_csv_reference_by_obj(obj)
    CsvReference.where(database_objectable_id: obj.id, database_objectable_type: obj.class.name).first_or_create.key
  end

  def get_csv_reference_by_key(obj)
    CsvReference.where(key).first
  end

end