class ChangeSectionToStage < ActiveRecord::Migration
    def change
        rename_table :sections, :stages
        rename_column :line_items, :section_id, :stage_id
    end
end
