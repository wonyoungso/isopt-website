class AddStartedAtAndEndedAtToEventIsopts < ActiveRecord::Migration
  def change
    add_column :event_isopts, :started_at, :datetime
    add_column :event_isopts, :ended_at, :datetime
  end
end
