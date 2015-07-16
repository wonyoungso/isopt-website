class RemoveEventIsoptIdAndDeviceId < ActiveRecord::Migration
  def change
    remove_column :users, :device_id
    remove_column :users, :event_isopt_id
  end
end
