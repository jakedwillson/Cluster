class CreateConversations < ActiveRecord::Migration[5.2]
  def change
    create_table :conversations do |t|
     t.integer :sender_id, index: true
     t.integer :recipient_id, index: true
     t.timestamps
    end
  end
end