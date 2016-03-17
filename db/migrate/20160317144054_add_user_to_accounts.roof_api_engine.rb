# This migration comes from roof_api_engine (originally 20160314162519)
class AddUserToAccounts < ActiveRecord::Migration
  def change
    add_reference :accounts, :user, polymorphic: true, index: true
  end
end
