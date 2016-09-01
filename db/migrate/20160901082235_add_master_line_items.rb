class AddMasterLineItems < ActiveRecord::Migration
  def up
    LineItem.reset_master
  end

  def down

  end
end
