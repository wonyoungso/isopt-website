class ChangeMomentRecordName < ActiveRecord::Migration
  def change
    rename_table :minute_records, :moment_records
  end
end
