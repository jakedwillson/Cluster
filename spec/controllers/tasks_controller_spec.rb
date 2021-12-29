require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let!(:task) { FactoryBot.create(:task, team_id: team.id) }
  let!(:user) { FactoryBot.create(:user) }
  let!(:team) { FactoryBot.create(:team) }

  before do
    TeamUser.create(team_id: team.id, user_id: user.id)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe "GET #index" do
    subject { get :index }

    it { is_expected.to have_http_status(:success) }
  end

  describe "GET #new" do
    subject { get :new, params: { team_id: team.id } }

    it { is_expected.to have_http_status(:success) }
  end

  describe 'POST #create' do
    subject { post :create,  :params => { :task => { name: name }, team_id: team.id } }

    context 'when valid parameters' do
      let(:name) { "TaskName" }

      it { is_expected.to redirect_to(team_path(team)) }
      it { subject ; expect(team.reload.tasks.count).to eq(2) }
    end

    context 'when invalid parameters' do
      let(:name) { nil }

      it { is_expected.to redirect_to(new_task_path(team_id: team.id)) }
      it { subject ; expect(team.reload.tasks.count).to eq(1) }
    end
  end

  describe "GET #show" do
    subject { get :show, params: { id: task_id } }

    context 'when valid id' do
      let(:task_id) { task.id }

      it { is_expected.to have_http_status(:success) }
    end

    context 'when invalid id' do
      let(:task_id) { 99 }

      it { is_expected.to redirect_to(root_url) }
    end

    context 'when nil id' do
      let(:task_id) { nil }

      it { is_expected.to redirect_to(root_url) }
    end
  end

  describe "GET #edit" do
    subject { get :edit, params: { id: task_id } }

    context 'when valid id' do
      let(:task_id) { task.id }

      it { is_expected.to have_http_status(:success) }
    end

    context 'when invalid id' do
      let(:task_id) { 99 }

      it { is_expected.to redirect_to(root_url) }
    end

    context 'when nil id' do
      let(:task_id) { nil }

      it { is_expected.to redirect_to(root_url) }
    end
  end

  describe "GET #delete" do
    subject { post :delete, params: { id: task_id } }

    context 'when valid id' do
      let(:task_id) { task.id }

      it { is_expected.to redirect_to(team_path(team)) }
    end

    context 'when invalid id' do
      let(:task_id) { 99 }

      it { is_expected.to redirect_to(root_url) }
    end

    context 'when nil id' do
      let(:task_id) { nil }

      it { is_expected.to redirect_to(root_url) }
    end
  end

  describe "GET #take" do
    subject { get :take, params: { id: task_id }, session: { user_id: user.id } }

    context 'when valid id' do
      let(:task_id) { task.id }

      it { is_expected.to redirect_to(team_path(team)) }
      it { subject ; expect(Task.find_by_id(task_id).status).to eq(2) }
      it { subject ; expect(Task.find_by_id(task_id).user_id).to eq(user.id) }
      it { subject ; expect(task.reload.status).to eq(2) }
      it { subject ; expect(task.reload.user_id).to eq(user.id) }
    end

    context 'when invalid id' do
      let(:task_id) { 99 }

      it { is_expected.to redirect_to(root_url) }
    end

    context 'when nil id' do
      let(:task_id) { nil }

      it { is_expected.to redirect_to(root_url) }
    end
  end

  describe 'POST #update' do
    subject { post :update, :params => { :task => { name: name, note: note }, id: task.id } }
    let(:note) { "NewNote" }

    context 'when valid parameters' do
      let(:name) { "NewName" }

      it { is_expected.to redirect_to(team_path(team)) }
      it { subject ; expect(task.reload.name).to eq(name) }
      it { subject ; expect(task.reload.note).to eq(note) }
    end

    context 'when invalid parameters' do
      let(:name) { nil }

      it { is_expected.to redirect_to(team_path(team)) }
      it { subject ; expect(task.reload.name).to eq(task.name) }
      it { subject ; expect(task.reload.note).to eq(task.note) }
    end
  end
end