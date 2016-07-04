class AddMetaToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :meta, :jsonb
  end
end
