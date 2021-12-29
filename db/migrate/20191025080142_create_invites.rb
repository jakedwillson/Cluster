class CreateInvites < ActiveRecord::Migration[5.2]
  def change
    create_table :invites do |t|
      t.string :email, index: true, null: false
      t.integer :sender_id, null: false
      t.integer :team_id, null: false
      t.integer :user_id, null: true
      t.string :token, null: false
      t.boolean :accepted, default: false, null: false
      t.timestamps
    end
    add_index :invites, :token, unique: true
  end
end
