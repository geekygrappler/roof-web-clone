module TaskCsvReset
  extend ActiveSupport::Concern

  included do
  end

  module ClassMethods
    def reset_master
        CSV.foreach(Rails.root.join('db', 'tasks.csv'), :headers => true) do |row|
          # 0 display in search
          # 1 display in quote - name
          # 2 group
          # 3 action
          # 4 description
          # 5 quantity
          # 6 unit
          # 7 searchable
          # 8 rate
          next if !row[0]
          searchable = row[7] == 'Yes' ? true : false
          unit = row[6].nil? ? 'unitless' : row[6]
          unit_id = Unit.where(name: unit).first_or_create
          data = {
              name: row[1],
              description: row[4],
              quantity: row[5],
              searchable: searchable,
              unit_id: unit_id,
              admin_verified: true,
              rate: row[8].to_i
          }
          LineItem.create(data)
        end
    end
  end
end
