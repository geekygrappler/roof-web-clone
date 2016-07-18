class ReplaceTasks < ActiveRecord::Migration
  def up
    require 'csv'
    Task.destroy_all
    CSV.foreach(Rails.root.join("task_db.csv"), :headers => true) do |row|
      # 0 display in search
      # 1 display in quote - name
      # 2 group
      # 3 action
      # 4 description
      # 5 quantity
      # 6 unit
      # 7 searchable
      # 8 rate
      searchable = row[7] == 'Yes' ? true : false
      unit = row[6].nil? ? 'unitless' : row[6]
      data = {
          search_name: row[0],
          name: row[1],
          group: row[2],
          action: row[3],
          description: row[4],
          quantity: row[5],
          unit: unit,
          searchable: searchable,
          price: row[8]
      }
      Task.create(data: data)
    end
  end
  def down

  end
end
