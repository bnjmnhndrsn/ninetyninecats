class AddSessionTable < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.string :session_token, null: false
      t.integer :user_id, null: false
      t.string :ip_address
      t.string :device
      t.string :location

      t.timestamps
    end
    
    add_index :sessions, :session_token, unique: true
    remove_column :users, :session_token
  end
end
