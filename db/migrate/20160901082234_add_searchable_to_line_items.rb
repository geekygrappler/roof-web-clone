class AddSearchableToLineItems < ActiveRecord::Migration
  def change
    add_column :line_items, :searchable, :boolean, default: false
  end
end
