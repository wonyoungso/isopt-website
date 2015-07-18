class AddConsensusTimeCodeToEventIsopts < ActiveRecord::Migration
  def change
    add_column :event_isopts, :consensus_time_code, :text
  end
end
