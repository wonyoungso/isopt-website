class AddIsResettableToEventIsopts < ActiveRecord::Migration
  def change
    add_column :event_isopts, :is_resettable, :boolean, :default => true
  end
end
