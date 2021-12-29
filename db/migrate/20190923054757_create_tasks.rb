class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.references :team, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: true
      t.string :name, null: false, limit: 60
      t.text :note, null: true, limit: 1000
      t.date :deadline, null: true
      t.string :github_url, null: true
      t.integer :status, null: false, default: 1
      t.string :user_status, null: false, default: "Not Started"
      t.timestamps
    end
  end
end
