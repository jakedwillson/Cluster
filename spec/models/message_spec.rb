require 'rails_helper'

RSpec.describe Message, type: :model do
  describe '#sender' do
    let!(:user) { FactoryBot.create(:user) }
    subject { FactoryBot.build(:message, sender_id: user.id).sender }

    it { is_expected.to eq(user) }
  end

  describe '#conversation' do
    let!(:conversation) { FactoryBot.create(:conversation) }
    let!(:message) { FactoryBot.create(:message, conversation_id: conversation.id, sender_id: conversation.sender_id) }
    subject { message.conversation }

    it { is_expected.to eq(conversation) }
    it { expect(conversation.messages).to include(message) }
  end

  describe '.sender_id' do
    let!(:conversation) { FactoryBot.create(:conversation) }
    subject { FactoryBot.build(:message, sender_id: sender_id, conversation_id: conversation.id) }

    context 'when valid (sender)' do
      let(:sender_id) { conversation.recipient_id }

      it { is_expected.to be_valid }
    end

    context 'when valid (recipient)' do
      let(:sender_id) { conversation.sender_id }

      it { is_expected.to be_valid }
    end

    context 'when invalid (different user)' do
      let!(:sender_id) { FactoryBot.create(:user).id }

      it { is_expected.not_to be_valid }
    end

    context 'when invalid (integer)' do
      let!(:sender_id) { 99 }

      it { is_expected.not_to be_valid }
    end
  end
end
