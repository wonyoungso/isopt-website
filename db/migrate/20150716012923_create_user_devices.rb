class CreateUserDevices < ActiveRecord::Migration
  def change
    create_table :user_devices do |t|
      t.integer :user_id
      t.integer :device_id
      t.integer :event_isopt_id

      t.timestamps null: false
    end
  end
end
