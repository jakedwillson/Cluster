require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#task_assignment(team)' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:team) { FactoryBot.create(:team) }

    before { team.add_user(user) }

    subject { user.task_assignment(team) }

    context 'when user is assigned task on team (active task)' do
      let!(:task) { FactoryBot.create(:task, team_id: team.id, user_id: user.id, status: 2) }

      it { is_expected.to eq(task) }
    end

    context 'when user is assigned task on team (complete task)' do
      let!(:task) { FactoryBot.create(:task, team_id: team.id, user_id: user.id, status: 3) }

      it { is_expected.to be_nil }
    end

    context 'when user is not assigned task on team' do
      it { is_expected.to eq(nil) }
    end
  end

  describe '#conversations' do
    let!(:user) { FactoryBot.create(:user) }
    subject { user.conversations }

    context 'when no conversations' do
      it { is_expected.to eq([]) }
    end

    context 'when 1 conversation (sender_id)' do
      let!(:conversation) { FactoryBot.create(:conversation, sender_id: user.id) }

      it { is_expected.to include(conversation) }
    end

    context 'when 1 conversation (recipient_id)' do
      let!(:conversation) { FactoryBot.create(:conversation, recipient_id: user.id) }

      it { is_expected.to include(conversation) }
    end

    context 'when 2 conversations' do
      let!(:c1) { FactoryBot.create(:conversation, recipient_id: user.id) }
      let!(:c2) { FactoryBot.create(:conversation, sender_id: user.id) }

      it { is_expected.to include(c1) }
      it { is_expected.to include(c2) }
    end

    context 'when 4 conversations' do
      let!(:c1) { FactoryBot.create(:conversation, recipient_id: user.id) }
      let!(:c2) { FactoryBot.create(:conversation, sender_id: user.id) }
      let!(:c3) { FactoryBot.create(:conversation, recipient_id: user.id) }
      let!(:c4) { FactoryBot.create(:conversation, sender_id: user.id) }

      it { is_expected.to include(c1) }
      it { is_expected.to include(c2) }
      it { is_expected.to include(c3) }
      it { is_expected.to include(c4) }
    end
  end

  describe '.username' do
    subject { FactoryBot.build(:user, username: username) }

    context 'when name is nil' do
      let(:username) { nil }

      it { is_expected.not_to be_valid }
    end

    context 'when name is too short' do
      let(:username) { "a" * 4 }

      it { is_expected.not_to be_valid }
    end

    context 'when name is min length' do
      let(:username) { "a" * 5 }

      it { is_expected.to be_valid }
    end

    context 'when name is max length' do
      let(:username) { "a" * 15 }

      it { is_expected.to be_valid }
    end

    context 'when name is too long' do
      let(:username) { "a" * 16 }

      it { is_expected.not_to be_valid }
    end
  end

  describe '.first_name' do
    subject { FactoryBot.build(:user, first_name: first_name) }

    context 'when name is nil' do
      let(:first_name) { nil }

      it { is_expected.to be_valid }
    end

    context 'when name includes a number' do
      let(:first_name) { "a" * 10 + "3" }

      it { is_expected.not_to be_valid }
    end

    context 'when name is too short' do
      let(:first_name) { "a" * 1 }

      it { is_expected.not_to be_valid }
    end

    context 'when name is min length' do
      let(:first_name) { "a" * 2 }

      it { is_expected.to be_valid }
    end

    context 'when name is max length' do
      let(:first_name) { "a" * 20 }

      it { is_expected.to be_valid }
    end

    context 'when name is too long' do
      let(:first_name) { "a" * 21 }

      it { is_expected.not_to be_valid }
    end
  end

  describe '.email' do
    subject { FactoryBot.build(:user, email: email) }
    
    context 'when format is valid' do
      let(:email) { 'john@gmail.com' }

      it { is_expected.to be_valid }
    end
    
    context 'when format is invalid' do
      let(:email) { 'johngmailcom' }
      
      it { is_expected.not_to be_valid }
    end

    context 'when value is not unique' do
      let(:email) { 'john@gmail.com' }

      before { FactoryBot.create(:user, email: email) }

      it { is_expected.not_to be_valid }
    end

    context 'when value is not unique (case diff)' do
      let(:email) { 'john@gmail.com' }

      before { FactoryBot.create(:user, email: email.upcase) }

      it { is_expected.not_to be_valid }
    end

    context 'when email max length' do
      let(:email) { 'a' * 50 + '@gmail.com' }

      it { is_expected.to be_valid }
    end

    context 'when email too long' do
      let(:email) { 'a' * 51 + '@gmail.com' }

      it { is_expected.not_to be_valid }
    end

    context 'when email too short' do
      let(:email) { 'a@g.com' }

      it { is_expected.not_to be_valid }
    end

    context 'when email min length' do
      let(:email) { 'ab@g.com' }

      it { is_expected.to be_valid }
    end
  end

  describe '#capitalize_names' do
    let!(:user) { FactoryBot.create(:user, first_name: "john", last_name: "doe") }

    it { expect(user.first_name).to eq("John") }
    it { expect(user.last_name).to eq("Doe") }
  end

  describe '#all_associated_teams' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:team1) { FactoryBot.create(:team) }
    let!(:team2) { FactoryBot.create(:team) }

    subject { user.all_associated_teams }

    context 'when one associated team' do
      before { team1.add_user(user) }

      it { is_expected.to eq([team1]) }
    end

    context 'when two associated teams' do
      before do
        team1.add_user(user)
        team2.add_user(user)
      end

      it { is_expected.to include(team1) }
      it { is_expected.to include(team2) }
    end

    context 'when no associated teams' do
      it { is_expected.to eq([]) }
    end
  end

  describe '#activate_accepted_invites' do
    let!(:user) { FactoryBot.create(:user) }

    let!(:team1) { FactoryBot.create(:team) }
    let!(:team2) { FactoryBot.create(:team) }
    let!(:team3) { FactoryBot.create(:team) }

    subject { user.activate_accepted_invites }

    context 'when 3 teams associated' do
      before do
        FactoryBot.create(:invite, email: user.email, team_id: team1.id, accepted: true)
        FactoryBot.create(:invite, email: user.email, team_id: team2.id, accepted: true)
        FactoryBot.create(:invite, email: user.email, team_id: team3.id, accepted: true)
        subject
      end

      it { expect(TeamUser.find_by(user_id: user.id, team_id: team1.id)).not_to be_nil }
      it { expect(TeamUser.find_by(user_id: user.id, team_id: team2.id)).not_to be_nil }
      it { expect(TeamUser.find_by(user_id: user.id, team_id: team3.id)).not_to be_nil }
    end

    context 'when 2 teams associated' do
      before do
        FactoryBot.create(:invite, email: user.email, team_id: team1.id, accepted: true)
        FactoryBot.create(:invite, email: user.email, team_id: team2.id, accepted: true)
        FactoryBot.create(:invite, email: user.email, team_id: team3.id, accepted: false)
        subject
      end

      it { expect(TeamUser.find_by(user_id: user.id, team_id: team1.id)).not_to be_nil }
      it { expect(TeamUser.find_by(user_id: user.id, team_id: team2.id)).not_to be_nil }
      it { expect(TeamUser.find_by(user_id: user.id, team_id: team3.id)).to be_nil }
    end

    context 'when 1 team associated' do
      before do
        FactoryBot.create(:invite, email: user.email, team_id: team1.id, accepted: true)
        FactoryBot.create(:invite, email: user.email, team_id: team2.id, accepted: false)
        FactoryBot.create(:invite, email: user.email, team_id: team3.id, accepted: false)
        subject
      end

      it { expect(TeamUser.find_by(user_id: user.id, team_id: team1.id)).not_to be_nil }
      it { expect(TeamUser.find_by(user_id: user.id, team_id: team2.id)).to be_nil }
      it { expect(TeamUser.find_by(user_id: user.id, team_id: team3.id)).to be_nil }
    end

    context 'when 1 team associated' do
      it { subject ; expect(TeamUser.count).to eq(0) }
    end
  end

  describe '#full_name' do
    subject { FactoryBot.create(:user, first_name: 'john', last_name: 'doe').full_name }

    it { is_expected.to eq("John Doe") }
  end

  describe '#email_activate' do
    let!(:user) { FactoryBot.create(:user) }
    subject { user.email_confirmed }

    context 'after it has been activated' do
      before { user.email_activate }

      it { is_expected.to be_truthy }
    end

    it { is_expected.to be_falsy }
  end
end