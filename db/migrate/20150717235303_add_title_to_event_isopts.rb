class AddTitleToEventIsopts < ActiveRecord::Migration
  def change
    add_column :event_isopts, :title, :string
  end
end
