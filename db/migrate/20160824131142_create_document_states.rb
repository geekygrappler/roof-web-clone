class CreateDocumentStates < ActiveRecord::Migration
  def change
    create_table :document_states do |t|
      t.string :name
      t.text :description

      t.timestamps null: false
    end
  end
end
