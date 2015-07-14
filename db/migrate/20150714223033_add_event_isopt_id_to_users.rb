class AddEventIsoptIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :event_isopt_id, :integer
  end
end
