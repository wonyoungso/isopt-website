class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :human_id
      t.string :sim_card_id

      t.timestamps null: false
    end
  end
end
