# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# require 'csv'
#
#
# CSV.foreach("#{Rails.root}/db/tasks.csv", {headers: true}) do |row|
#   # Task_action,Task_item,Task_group,Default quanity,Task _units,Task_rate,Task_searchable,Task_searchable_name
#   # action = TaskAction.find_or_create_by(name: row[0])
#   # group = TaskGroup.find_or_create_by(name: row[2])
#   action = row[0]
#   group = row[2]
#   task = Task.create(group: group, action: action, name: row[1], quantity: row[3], price: row[5], searchable: true, tags: [row[7]])
#   if task.persisted?
#     puts task.as_json
#   else
#     puts task.errors.as_json
#   end
# end
