class AddIsPublishedToEventIsopts < ActiveRecord::Migration
  def change
    add_column :event_isopts, :is_published, :boolean, :default => false
  end
end
