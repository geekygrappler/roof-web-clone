# This migration comes from roof_api_engine (originally 20160331110656)
class AddMetaToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :meta, :jsonb
  end
end
