class DocumentHasManySections < ActiveRecord::Migration
    def self.up
        add_column :sections, :document_id, :integer
        add_index 'sections', ['document_id'], :name => 'index_document_id'
    end

    def self.down
        remove_column :sections, :document_id
    end
end
