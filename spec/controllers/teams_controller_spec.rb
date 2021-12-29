require 'rails_helper'

RSpec.describe TeamsController, type: :controller do
  let!(:team) { FactoryBot.create(:team) }
  let!(:user) { FactoryBot.create(:user) }

  describe "GET #index" do
    subject { get :index, session: { user_id: user.id } }

    let!(:team1) { FactoryBot.create(:team) }
    let!(:team2) { FactoryBot.create(:team) }
    let!(:team3) { FactoryBot.create(:team) }
    let!(:team4) { FactoryBot.create(:team) }

    let(:teams) { controller.instance_variable_get(:@teams) }

    context 'when added to 4 teams' do
      before do
        team1.add_user(user)
        team2.add_user(user)
        team3.add_user(user)
        team4.add_user(user)
        subject
      end

      it { is_expected.to have_http_status(:success) }
      it { expect(teams).to include(team1) }
      it { expect(teams).to include(team2) }
      it { expect(teams).to include(team3) }
      it { expect(teams).to include(team4) }
    end

    context 'when added to 2 teams' do
      before do
        team1.add_user(user)
        team4.add_user(user)
        subject
      end

      it { is_expected.to have_http_status(:success) }
      it { expect(teams).to include(team1) }
      it { expect(teams).not_to include(team2) }
      it { expect(teams).not_to include(team3) }
      it { expect(teams).to include(team4) }
    end

    context 'when added to 0 teams' do
      before { subject }

      it { is_expected.to have_http_status(:success) }
      it { expect(teams).to eq([]) }
    end

  end

  describe "GET #show" do
    subject { get :show, params: { id: team_id }, session: { user_id: user.id } }

    context 'when user is part of team' do
      let(:team_id) { team.id }

      before { team.add_user(user) }

      it { is_expected.to have_http_status(:success) }
    end

    context 'when user is not part of team' do
      let(:team_id) { team.id }

      it { is_expected.to redirect_to(root_url) }
    end

    context 'when id invalid' do
      let(:team_id) { 99 }

      it { is_expected.to redirect_to(root_url) }
    end
  end

  describe 'GET #new' do
    subject { get :new }

    it { is_expected.to have_http_status(:success) }
  end

  describe "GET #edit" do
    subject { get :edit, params: { id: team_id }, session: { user_id: user.id } }

    context 'when user is on team' do
      let(:team_id) { team.id }

      before { team.add_user(user) }

      it { is_expected.to have_http_status(:success) }
    end

    context 'when user is not on team' do
      let(:team_id) { team.id }

      it { is_expected.to redirect_to(root_url) }
    end

    context 'when id invalid' do
      let(:team_id) { 99 }

      it { is_expected.to redirect_to(root_url) }
    end
  end

  describe "POST #create" do
    let(:team_description) { "MyTeamDescription" }
    let(:team_name) { "MyTeamName" }
    let(:user_id) { user.id }

    context 'when no description' do
      subject { post :create, params: { :team => { name: team_name } }, session: { user_id: user_id } }

      it { is_expected.to redirect_to(Team.find_by(name: team_name, created_by: user_id)) }
    end

    context 'when both present' do
      subject { post :create, params: { :team => { name: team_name , description: team_description } }, session: { user_id: user_id } }

      it { is_expected.to redirect_to(Team.find_by(name: team_name, description: team_description, created_by: user_id)) }
    end

    context 'when name not present' do
      subject { post :create, params: { :team => { name: nil , description: team_description } }, session: { user_id: user_id } }

      it { is_expected.to render_template('new') }
    end
  end
end
