class AddIsActivatedToEventIsopts < ActiveRecord::Migration
  def change
    add_column :event_isopts, :is_activated, :boolean, :default => false
  end
end
