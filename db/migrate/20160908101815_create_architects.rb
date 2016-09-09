class CreateArchitects < ActiveRecord::Migration
  def change
    create_table :architects do |t|
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :postcode
      t.string :name
      t.string :email
      t.string :phone

      t.timestamps null: false
    end
    add_reference :documents, :architect
    remove_column :documents, :user_id
  end
end
