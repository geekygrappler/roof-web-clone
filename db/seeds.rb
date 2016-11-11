# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'csv'
require 'yaml'

# Create Items
current_item = nil
current_action = nil
CSV.foreach("#{Rails.root}/db/migration/items.csv",{headers: true, header_converters: :symbol, converters: :all}) do |row|
    row = row.to_hash
    if row[:item]
        current_item = Item.create(name: row[:item].strip)
    end
    if current_item
        if row[:item_action]
            current_action = ItemAction.find_or_create_by(name: row[:item_action].strip)
            current_item.item_actions << current_action
        end
        if row[:item_spec]
            current_spec = ItemSpec.create(name: row[:item_spec].strip, item: current_item)
            if row[:rate] && current_action && current_item
                Rate.create(
                    item: current_item,
                    item_action: current_action,
                    item_spec: current_spec,
                    rate: row[:rate].to_i * 100
                )
            end
        end
    end
end

# Create a master document
document_hash = YAML.load(File.read("#{Rails.root}/db/master_template_document.yml"))

master_document = Document.create(name: "Master Document")
document_hash["sections"].each do |section|
    new_section = master_document.sections.create(name: section["name"])
    if section["line_items"]
        section["line_items"].each do |name|
            LineItem.create(name: name, section: new_section, document: master_document)
        end
    end
end


#Account.create(email: 'admin@1roof.com', password: 'password', user_attributes: {type: 'Administrator', profile: {first_name: 'Admin', last_name: 'One', phone_number: '08999'}})
#Account.create(email: 'bot@1roof.com', password: 'password', user_attributes: {type: 'Administrator', profile: {first_name: 'Bot', last_name: 'Roof', phone_number: '000'}})
