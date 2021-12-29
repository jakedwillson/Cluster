class CreateTeamUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :team_users do |t|
      t.belongs_to :team
      t.belongs_to :user
    end
  end
end
