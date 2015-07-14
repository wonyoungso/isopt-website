class CreateEventIsopts < ActiveRecord::Migration
  def change
    create_table :event_isopts do |t|
      t.datetime :held_at
      t.string :venue_name

      t.timestamps null: false
    end
  end
end
