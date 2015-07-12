class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.boolean :admin
      t.string :device_id
      t.string :fullname

      t.timestamps null: false
    end
  end
end
