require 'rails_helper'

RSpec.describe InvitesController, type: :controller do
  let!(:team) { FactoryBot.create(:team) }
  let!(:current_user) { FactoryBot.create(:user) }
  let!(:user) { FactoryBot.create(:user) }

  before { allow(controller).to receive(:current_user).and_return(current_user) }

  describe 'POST create' do
    subject { post :create,  :params => { :invite => { email_or_username: email }, team_id: team.id, session: { user_id: current_user.id } } }

    context 'invite by email' do
      context 'when email is not recognized' do
        let(:email) { "email@email.com" }

        it { is_expected.to redirect_to(team) }
        it { expect{ subject }.to have_enqueued_job(SendInviteJob).with(Invite.first).exactly(:once) }

        context 'after execution' do
          before { subject }

          it { expect( Invite.first.email ).to eq(email) }
          it { expect( Invite.first.sender_id ).to eq(current_user.id) }
          it { expect( Invite.first.team_id ).to eq(team.id) }
        end
      end

      context 'when active user is referenced' do
        let(:email) { user.email }

        it { is_expected.to redirect_to(team) }
        it { expect{ subject }.to have_enqueued_job(SendInviteJob).with(Invite.first).exactly(:once) }

        context 'after execution' do
          before { subject }

          it { expect( Invite.first.email ).to eq(email) }
          it { expect( Invite.first.user_id ).to eq(user.id) }
          it { expect( Invite.first.sender_id ).to eq(current_user.id) }
          it { expect( Invite.first.team_id ).to eq(team.id) }
        end
      end
    end
  end

  describe 'GET accept' do
    context 'when pre-existing user accepts his invite' do
      subject { get :accept,  :params => { :token => invite.token, session: { user_id: user.id } } }

      let!(:invite) { FactoryBot.create(:invite, team_id: team.id, email: user.email) }

      before { allow(controller).to receive(:current_user).and_return(user) }

      it { is_expected.to redirect_to(team) }
      it { subject ; expect(Invite.first.accepted).to be_truthy }
      it { subject ; expect(TeamUser.find_by(team_id: team.id, user_id: user.id)).not_to be_nil }
    end

    context 'when non-user accepts an invite' do
      subject { get :accept,  :params => { :token => invite.token } }

      let!(:invite) { FactoryBot.create(:invite, team_id: team.id, email: email) }
      let(:email) { "randomemail@email.com" }

      before { allow(controller).to receive(:current_user).and_return(nil) }

      it { is_expected.to redirect_to(signup_url) }
      it { subject ; expect(Invite.first.accepted).to be_truthy }
      it { subject ; expect(TeamUser.count).to eq(0) }
    end

    context 'when different user is logged in' do
      subject { get :accept,  :params => { :token => invite.token }, session: { user_id: current_user.id } }

      let!(:invite) { FactoryBot.create(:invite, team_id: team.id, email: email) }

      context 'email to pre-existing user' do
        let(:email) { user.email }

        before { allow(controller).to receive(:current_user).and_return(current_user) }

        it { is_expected.to redirect_to(logout_url) }
        it { subject ; expect(Invite.first.accepted).to be_truthy }
        it { subject ; expect(TeamUser.count).to eq(1) }
      end

      context 'email to new user' do
        let(:email) { "randomemail@email.com" }

        before { allow(controller).to receive(:current_user).and_return(current_user) }

        it { is_expected.to redirect_to(logout_url) }
        it { subject ; expect(Invite.first.accepted).to be_truthy }
        it { subject ; expect(TeamUser.count).to eq(0) }
      end
    end
  end

  context '#is_email' do
    subject { controller.is_email?(str) }

    context 'when true' do
      let(:str) { "email@email.com" }

      it { is_expected.to be_truthy }
    end

    context 'when true' do
      let(:str) { "username" }

      it { is_expected.to be_falsey }
    end
  end
end
