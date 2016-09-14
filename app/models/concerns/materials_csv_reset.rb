module MaterialsCsvReset
  extend ActiveSupport::Concern

  included do
  end

  module ClassMethods
    def reset_master
      CSV.foreach(Rails.root.join('db', 'materials.csv'), :headers => true) do |row|
        # 0 name
        next if !row[0]
        data = {
            name: row[0]
        }
        BuildingMaterial.create(data)
      end
    end
  end
end
