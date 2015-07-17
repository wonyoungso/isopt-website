class AddTzOffsetToEventIsopts < ActiveRecord::Migration
  def change
    add_column :event_isopts, :tz_offset, :string, :default => '-0500'
  end
end
