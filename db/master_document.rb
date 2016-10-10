# This file should contain a way to create a master document. The idea being that we can
# base other documents off this one.
require 'yaml'

document_hash = Hash.new(YAML.load(File.read(File.expand_path('../template_document.yml', __FILE__))))

master_document = Document.create(name: "Master Document")
document_hash["sections"].each do |name, line_items|
    section = master_document.sections.create(name: name)
    line_items.each do |name|
        parent_line_item = LineItem.where(name: name, searchable: true).first
        if parent_line_item
            line_item = parent_line_item.dup
            line_item.line_item = parent_line_item
            line_item.searchable = false
            line_item.admin_verified = false
            if line_item.save
                section.line_items << line_item
            end
        end
    end
end
