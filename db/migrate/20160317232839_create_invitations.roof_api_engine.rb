# This migration comes from roof_api_engine (originally 20160317224529)
class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.references :project, index: true, foreign_key: true
      t.references :inviter, index: true
      t.references :invitee, index: true
      t.jsonb :data, default: {}

      t.timestamps null: false
    end
  end
end
