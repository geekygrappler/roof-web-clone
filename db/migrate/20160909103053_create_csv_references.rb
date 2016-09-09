class CreateCsvReferences < ActiveRecord::Migration
  def change
    create_table :csv_references do |t|
      t.string :key
      t.references :database_objectable, polymorphic: true, index: {name: 'csv_ref_poly_index'}

      t.timestamps null: false
    end
    add_index :csv_references, :key
  end
end
