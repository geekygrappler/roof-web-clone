# This migration comes from roof_api_engine (originally 20160324022106)
class CreateContentTemplates < ActiveRecord::Migration
  def change
    create_table :content_templates do |t|
      t.text :body
      t.string :path
      t.string :locale
      t.string :format
      t.string :handler
      t.boolean :partial

      t.timestamps null: false
    end
    add_index :content_templates, [:path, :locale, :format, :handler, :partial], name: "index_content_templates", unique: true
  end
end
