class CreateUserDeviceLogs < ActiveRecord::Migration
  def change
    create_table :user_device_logs do |t|
      t.integer :user_device_id
      t.text :description

      t.timestamps null: false
    end
  end
end
