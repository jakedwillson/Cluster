require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe "GET #new" do
    subject { get :new }

    it { is_expected.to have_http_status(:success) }
  end

  describe "GET #create" do
    subject { get :create, params: { email: email , password: password } }
    let!(:user) { FactoryBot.create(:user, password: "MyPassword") }

    context 'when no email or password provided' do
      let(:email) { nil }
      let(:password) { nil }

      it { is_expected.to have_http_status(:success) }
      it { is_expected.to render_template("new") }
    end
    
    context 'when valid authentication' do
      let(:email) { user.email }
      let(:password) { "MyPassword" }

      it { is_expected.to redirect_to(home_url)}
    end

    context 'when invalid authentication' do
      let(:email) { user.email }
      let(:password) { user.password + '!' }

      it { is_expected.to have_http_status(:success) }
      it { is_expected.to render_template("new") }
    end
  end

  describe "GET #destroy" do
    subject { get :destroy }

    it { is_expected.to redirect_to(root_url) }
  end
end