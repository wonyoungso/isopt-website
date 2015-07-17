class AddIsEndedToEventIsopts < ActiveRecord::Migration
  def change
    add_column :event_isopts, :is_ended, :boolean
  end
end
