class CreateFriendChats < ActiveRecord::Migration
  def self.up
    create_table :friend_chats do |t|
      t.text :message
      t.integer :user_id
      t.integer :receiver_id
      t.string :timestamp

      t.timestamps
    end
  end

  def self.down
    drop_table :friend_chats
  end
end
