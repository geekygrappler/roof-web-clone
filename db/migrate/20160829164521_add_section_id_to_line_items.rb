class AddSectionIdToLineItems < ActiveRecord::Migration
  def change
    add_reference :line_items, :section, index: true, foreign_key: true
  end
end
