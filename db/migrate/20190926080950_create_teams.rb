class CreateTeams < ActiveRecord::Migration[5.2]
  def change
    create_table :teams do |t|
      t.string :name, null: false
      t.string :github_url
      t.string :description, limit: 5000
      t.integer :created_by, null: false
      t.timestamps
    end
  end
end
