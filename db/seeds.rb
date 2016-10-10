# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'csv'
require 'yaml'

# Task.delete_all
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

CSV.foreach("#{Rails.root}/db/line_items.csv", {headers: true, skip_blanks: true}) do |row|
    if row["spec"]
        row["name"] += " - #{row["spec"]}"
    end

    row.delete("spec")

    row["quantity"].nil? ? row["quantity"] = 1 : nil

    line_item_attrs = row.to_h
    line_item_attrs["searchable"] = true
    line_item_attrs["admin_verified"] = true
    line_item_attrs["rate"] = line_item_attrs["rate"].to_i * 100

    line_item = LineItem.create(line_item_attrs)
end

document_hash = YAML.load(File.read("#{Rails.root}/db/template_document.yml"))

master_document = Document.create(name: "Master Document")
document_hash["sections"].each do |section|
    new_section = master_document.sections.create(name: section["name"])
    if section["line_items"]
        section["line_items"].each do |name|
            parent_line_item = LineItem.where(name: name, searchable: true).first
            if parent_line_item
                line_item = parent_line_item.dup
                line_item.line_item = parent_line_item
                line_item.searchable = false
                line_item.admin_verified = false
                if line_item.save
                    new_section.line_items << line_item
                end
            end
        end
    end
end


#Account.create(email: 'admin@1roof.com', password: 'password', user_attributes: {type: 'Administrator', profile: {first_name: 'Admin', last_name: 'One', phone_number: '08999'}})
#Account.create(email: 'bot@1roof.com', password: 'password', user_attributes: {type: 'Administrator', profile: {first_name: 'Bot', last_name: 'Roof', phone_number: '000'}})
