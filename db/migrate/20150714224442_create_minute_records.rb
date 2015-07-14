class CreateMinuteRecords < ActiveRecord::Migration
  def change
    create_table :minute_records do |t|
      t.integer :milliseconds
      t.datetime :submitted_at
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
