class CreateDocumentInvitations < ActiveRecord::Migration
  def change
    create_table :document_invitations do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.boolean :sent_email, default: false
      t.references :document, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
