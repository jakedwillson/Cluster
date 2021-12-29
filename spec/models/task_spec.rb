require 'rails_helper'

RSpec.describe Task, type: :model do
  describe '#user' do
    let!(:user) { FactoryBot.create(:user) }
    subject { FactoryBot.create(:task, user_id: user.id).user }

    it { is_expected.to eq(user) }
  end

  describe '#mark_complete!' do
    let!(:task) { FactoryBot.create(:task) }

    subject { task.mark_complete! }

    it { expect(task.reload.status).to eq(1) }
    it { subject ; expect(task.reload.status).to eq(3) }
  end

  describe '#return_to_queue!' do
    let!(:task) { FactoryBot.create(:task, status: 2) }

    subject { task.return_to_queue! }

    it { expect(task.reload.status).to eq(2) }
    it { subject ; expect(task.reload.status).to eq(1) }
  end

  describe '#team' do
    let!(:team) { FactoryBot.create(:team) }
    let!(:task) { FactoryBot.create(:task, team_id: team.id) }

    subject { task.team }

    it { is_expected.to eq(team) }
  end

  describe '.user_status' do
    subject { FactoryBot.build(:task, user_status: status) }

    context 'when present' do
      let(:status) { "Coding" }

      it { is_expected.to be_valid }
    end

    context 'when absent' do
      let(:status) { nil }

      it { is_expected.to be_valid }
    end
  end

  describe '.user_status (default)' do
    context 'when no user' do
      let!(:task) { FactoryBot.create(:task, user_id: nil, user_status: nil) }

      it { expect(task.user_status).to eq("Not Started") }
    end

    context 'when no user' do
      let!(:task) { FactoryBot.create(:task, user_id: FactoryBot.create(:user).id, user_status: nil) }

      it { expect(task.user_status).to eq("Not Started") }
    end
  end

  describe '.team_id' do
    subject { FactoryBot.build(:task, team_id: team_id) }

    context 'when valid id' do
      let!(:team_id) { FactoryBot.create(:team).id }

      it { is_expected.to be_valid }
    end

    context 'when invalid id' do
      let!(:team_id) { 99 }

      it { is_expected.not_to be_valid }
    end

    context 'when nil' do
      let!(:team_id) { nil }

      it { is_expected.not_to be_valid }
    end
  end

  describe '.user_id' do
    subject { FactoryBot.build(:task, user_id: user_id) }

    context 'when valid' do
      let!(:user_id) { FactoryBot.create(:user).id }

      it { is_expected.to be_valid }
    end

    context 'when invalid' do
      let(:user_id) { 99 }

      it { is_expected.not_to be_valid }
    end

    context 'when nil' do
      let(:user_id) { nil }

      it { is_expected.to be_valid }
    end
  end

  describe '.name' do
    subject { FactoryBot.build(:task, name: name) }

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

  describe '.note' do
    subject { FactoryBot.build(:task, note: note) }

    context 'when note is nil' do
      let(:note) { nil }

      it { is_expected.to be_valid }
    end

    context 'when note is 1 char' do
      let(:note) { 'a' }

      it { is_expected.to be_valid }
    end

    context 'when note is max length' do
      let(:note) { 'a' * 1000 }

      it { is_expected.to be_valid }
    end

    context 'when note is too long' do
      let(:note) { 'a' * 1001 }

      it { is_expected.not_to be_valid }
    end
  end

  describe '.status' do
    subject { FactoryBot.build(:task, status: status) }

    context 'when no status specified' do
      let(:status) { nil }

      it { is_expected.to be_valid }
    end
  end

  describe '#default_values' do
    let!(:task) { FactoryBot.create(:task) }

    it { expect(task.status).to eq(1) }
    it { expect(task.deadline).to eq(Date.today + 5) }
  end

  describe '#assign_user' do
    let!(:team) { FactoryBot.create(:team) }
    let!(:task) { FactoryBot.create(:task, team_id: team.id) }

    subject { task.assign_user(user) }

    context 'when valid user' do
      let!(:user) { FactoryBot.create(:user) }

      before do
        team.add_user(user)
        subject
      end

      it { expect(task.user_id).to eq(user.id) }
      it { expect(User.find_by_id(task.user_id)).to eq(user) }
    end

    context 'when invalid user' do
      let!(:user) { FactoryBot.create(:user) }

      it { is_expected.to eq(I18n.t('model.team.errors.user_not_on_team')) }
      it { expect(task.user_id).not_to eq(user.id) }
      it { expect(User.find_by_id(task.user_id)).not_to eq(user) }
    end

    context 'when invalid user' do
      let!(:user) { nil }

      it { is_expected.to eq(I18n.t('model.user.errors.invalid_user_id')) }
    end
  end
end
