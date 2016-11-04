class CreateRates < ActiveRecord::Migration
    def change
        create_table :rates do |t|
            t.references :item, index: true, foreign_key: true
            t.references :item_spec, index: true, foreign_key: true
            t.references :item_action, index: true, foreign_key: true
            t.integer :rate
            t.string :formatted_rate

            t.timestamps null: false
        end
    end
end
