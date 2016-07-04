class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.references :project, index: true, foreign_key: true
      t.references :host, index: true, polymorphic: true
      t.references :attendant, index: true, polymorphic: true
      t.jsonb :data, default: {}

      t.timestamps null: false
    end
  end
end
