require 'rails_helper'

RSpec.describe TeamsHelper, type: :helper do
  let!(:user) { FactoryBot.create(:user) }
  let!(:current_user) { FactoryBot.create(:user) }
  let!(:team) { FactoryBot.create(:team) }

  describe '#direct_message_between_users' do
    let(:link) { helper.direct_message_between_users(user, current_user) }

    subject { link }

    context 'when pre-existing convo exists' do
      let!(:conversation) { Conversation.find_or_create!(user, current_user) }

      it { subject ; expect(link).to eq(conversations_show_path(id: conversation.id)) }
    end

    context 'when no pre-existing convo exists' do
      it { subject ; expect(link).to eq(conversations_show_path(id: Conversation.find_or_create!(user, current_user).id)) }
    end

    context 'when pre-existing convo exists (hard code)' do
      let!(:conversation) { FactoryBot.create(:conversation, sender_id: user.id, recipient_id: current_user.id) }

      it { subject ; expect(link).to eq(conversations_show_path(id: conversation.id)) }
    end

    context 'when pre-existing convo exists (flip)' do
      let!(:conversation) { Conversation.find_or_create!(current_user, user) }

      it { subject ; expect(link).to eq(conversations_show_path(id: conversation.id)) }
    end

    context 'when parameters invalid (same user)' do
      let!(:current_user) { user }

      it { subject ; expect(link).to be_nil }
    end

    context 'when parameters invalid (nil)' do
      let!(:current_user) { nil }

      it { subject ; expect(link).to be_nil }
    end
  end
end
