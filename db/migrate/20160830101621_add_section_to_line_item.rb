class AddSectionToLineItem < ActiveRecord::Migration
    def change
        add_column :line_items, :section_id, :integer
    end
end
