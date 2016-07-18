class CreateFailedPayments < ActiveRecord::Migration
  def up
    create_table :failed_payments do |t|
      t.jsonb :data
      t.string :message
      t.integer :payment_id

      t.timestamps null: false
    end
  end

  def down
    drop_table :failed_payments
  end
end
