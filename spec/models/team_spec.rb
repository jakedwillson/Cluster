require 'rails_helper'

RSpec.describe Team, type: :model do
  describe 'unassigned_tasks' do
    subject { team.unassigned_tasks }

    let!(:team) { FactoryBot.create(:team) }

    let!(:task1) { FactoryBot.create(:task, team_id: team.id, status: 2) }
    let!(:task2) { FactoryBot.create(:task, team_id: team.id, status: 3) }

    context 'when none' do
      it { is_expected.to eq([]) }
    end

    context 'when one' do
      let!(:task1) { FactoryBot.create(:task, team_id: team.id, status: 1) }

      it { is_expected.to include(task1) }
      it { is_expected.not_to include(task2) }
    end

    context 'when two' do
      let!(:task1) { FactoryBot.create(:task, team_id: team.id, status: 1) }
      let!(:task2) { FactoryBot.create(:task, team_id: team.id, status: 1) }

      it { is_expected.to include(task1) }
      it { is_expected.to include(task2) }
    end
  end

  describe 'finished_tasks' do
    subject { team.finished_tasks }

    let!(:team) { FactoryBot.create(:team) }

    let!(:task1) { FactoryBot.create(:task, team_id: team.id, status: 2) }
    let!(:task2) { FactoryBot.create(:task, team_id: team.id, status: 1) }

    context 'when none' do
      it { is_expected.to eq([]) }
    end

    context 'when one' do
      let!(:task1) { FactoryBot.create(:task, team_id: team.id, status: 3) }

      it { is_expected.to include(task1) }
      it { is_expected.not_to include(task2) }
    end

    context 'when two' do
      let!(:task1) { FactoryBot.create(:task, team_id: team.id, status: 3) }
      let!(:task2) { FactoryBot.create(:task, team_id: team.id, status: 3) }

      it { is_expected.to include(task1) }
      it { is_expected.to include(task2) }
    end
  end

  describe '#tasks' do
    let!(:team) { FactoryBot.create(:team) }
    subject { team.tasks }

    context 'when no tasks' do
      it { is_expected.to eq([]) }
    end

    context 'when one task' do
      let!(:task) { FactoryBot.create(:task, team_id: team.id) }

      it { is_expected.to include(task) }
    end

    context 'when two tasks' do
      let!(:task1) { FactoryBot.create(:task, team_id: team.id) }
      let!(:task2) { FactoryBot.create(:task, team_id: team.id) }

      it { is_expected.to include(task1) }
      it { is_expected.to include(task2) }
    end
  end
  
  describe '.name' do
    subject { FactoryBot.build(:team, name: name) }

    context 'when name is nil' do
      let(:name) { nil }

      it { is_expected.not_to be_valid }
    end

    context 'when name is min length' do
      let(:name) { 'a' }

      it { is_expected.to be_valid }
    end

    context 'when name is max length' do
      let(:name) { 'a' * 60 }

      it { is_expected.to be_valid }
    end

    context 'when name is too long' do
      let(:name) { 'a' * 61 }

      it { is_expected.not_to be_valid }
    end
  end

  describe '.created_by' do
    subject { FactoryBot.build(:team, created_by: created_by) }

    context 'when nil' do
      let(:created_by) { nil }

      it { is_expected.not_to be_valid }
    end

    context 'when invalid user id' do
      let(:created_by) { 99 }

      it { is_expected.not_to be_valid }
    end

    context 'when valid user id' do
      let!(:created_by) { FactoryBot.create(:user).id }

      it { is_expected.to be_valid }
    end
  end

  describe '.description' do
    subject { FactoryBot.build(:team, description: description) }

    context 'when nil' do
      let(:description) { nil }

      it { is_expected.to be_valid }
    end

    context 'when min length' do
      let(:description) { 'a' * 1 }

      it { is_expected.to be_valid }
    end

    context 'when max length' do
      let(:description) { 'a' * 1000 }

      it { is_expected.to be_valid }
    end

    context 'when too long' do
      let(:description) { 'a' * 1001 }

      it { is_expected.not_to be_valid }
    end
  end

  describe '#add_user' do
    let!(:team) { FactoryBot.create(:team) }

    subject { team.add_user(user) }

    context 'when user is provided' do
      let!(:user) { FactoryBot.create(:user) }

      before { subject }

      it { expect(user.all_associated_teams).to include(team) }
    end
  end

  describe '#remove_user' do
    let!(:team) { FactoryBot.create(:team) }
    let!(:user) { FactoryBot.create(:user) }

    before { team.add_user(user) }

    subject { team.remove_user(user) }

    it { subject ; expect(user.all_associated_teams).not_to include(team) }
  end

  describe 'users association' do
    let!(:team) { FactoryBot.create(:team) }
    let!(:user1) { FactoryBot.create(:user) }
    let!(:user2) { FactoryBot.create(:user) }

    subject { team.users }

    before do
      team.add_user(user1)
      team.add_user(user2)
    end

    it { is_expected.to include(user1) }
    it { is_expected.to include(user2) }
  end
end
