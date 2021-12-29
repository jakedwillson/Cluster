require 'rails_helper'

RSpec.describe TeamUser, type: :model do
  describe '.association' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:team) { FactoryBot.create(:team) }

    before { team.add_user(user) }

    it 'creates a db record' do
      expect(TeamUser.find_by(user_id: user.id, team_id: team.id)).not_to be_nil
    end
  end
end