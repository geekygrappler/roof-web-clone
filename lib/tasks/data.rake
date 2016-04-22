task :pro_and_roof_prices => :environment do
  CSV.open("#{Rails.application.root}/tmp/pro_and_roof_prices.csv", "wb") do |csv|
    Quote.pro_and_roof_prices.each_with_index do |row, index|
      if index == 0
        csv << row.keys
      end
      csv << row.values
    end
  end
end
task :tasks => :environment do
  CSV.open("#{Rails.application.root}/tmp/tasks.csv", "wb") do |csv|
    Task.all.each_with_index do |row, index|
      row = TaskSerializer.new(row).as_json
      if index == 0
        csv << row.keys
      end
      csv << row.values
    end
  end
end
