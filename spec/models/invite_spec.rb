require 'rails_helper'

RSpec.describe Invite, type: :model do
  describe 'token default value' do
    let!(:invite) { FactoryBot.create(:invite, token: nil) }

    it { expect(invite.token).not_to be_nil }
  end

  describe 'team_id' do
    subject { FactoryBot.build(:invite, team_id: team_id) }

    context 'when valid id' do
      let!(:team_id) { FactoryBot.create(:team).id }

      it { is_expected.to be_valid }
    end

    context 'when invalid id' do
      let!(:team_id) { 99 }

      it { is_expected.not_to be_valid }
    end
  end

  describe 'user_id' do
    let(:invite) { FactoryBot.create(:invite, email: email) }
    subject { invite }

    context 'when email matches active user' do
      let!(:user) { FactoryBot.create(:user) }
      let!(:email) { user.email }

      before { subject }

      it { expect(invite.user_id).to eq(user.id) }
    end

    context 'when email matches active user' do
      let!(:email) { "johndoe@gmail.com" }

      before { subject }

      it { expect(invite.user_id).to be_nil }
    end
  end
end
