class AddUserToAccounts < ActiveRecord::Migration
  def change
    add_reference :accounts, :user, polymorphic: true, index: true
  end
end
