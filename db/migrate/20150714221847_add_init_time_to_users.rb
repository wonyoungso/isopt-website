class AddInitTimeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :init_time, :integer
    add_column :users, :is_initialized, :boolean, :default => false
    add_column :users, :init_at, :datetime
  end
end
