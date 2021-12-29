class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :username, null: false, index: true, limit: 15
      t.string :first_name, null: true, limit: 20
      t.string :last_name, null: true, limit: 20
      t.string :password_hash
      t.timestamps
    end
  end
end
