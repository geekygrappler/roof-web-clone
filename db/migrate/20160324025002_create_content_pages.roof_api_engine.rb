# This migration comes from roof_api_engine (originally 20160324022216)
class CreateContentPages < ActiveRecord::Migration
  def change
    create_table :content_pages do |t|
      t.string :pathname
      t.text :body

      t.timestamps null: false
    end
  end
end
