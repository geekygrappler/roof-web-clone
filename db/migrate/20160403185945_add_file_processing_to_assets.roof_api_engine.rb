# This migration comes from roof_api_engine (originally 20160403185732)
class AddFileProcessingToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :file_processing, :boolean, null: false, default: false
    add_column :assets, :file_tmp, :string
  end
end
