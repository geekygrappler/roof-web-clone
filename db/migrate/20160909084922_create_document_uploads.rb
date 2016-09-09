class CreateDocumentUploads < ActiveRecord::Migration
  def change
    create_table :document_uploads do |t|
      t.references :document, index: true, foreign_key: true
      t.string :s3_url

      t.timestamps null: false
    end
  end
end
