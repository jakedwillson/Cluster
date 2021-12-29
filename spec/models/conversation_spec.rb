require 'rails_helper'

RSpec.describe Conversation, type: :model do
  let!(:user1) { FactoryBot.create(:user) }
  let!(:user2) { FactoryBot.create(:user) }

  describe '#opposite_person' do
    let!(:convo) { Conversation.find_or_create!(user1,user2) }
    subject { convo.opposite_person(user) }

    context 'when user1' do
      let!(:user) { user1 }

      it { is_expected.to eq(user2) }
    end

    context 'when user2' do
      let!(:user) { user2 }

      it { is_expected.to eq(user1) }
    end

    context 'when wrong user' do
      let!(:user) { FactoryBot.create(:user) }

      it { is_expected.to be_nil }
    end

    context 'when nil' do
      let!(:user) { nil }

      it { is_expected.to be_nil }
    end
  end

  describe '#sender/#recipient' do
    let!(:conv) { Conversation.find_or_create!(user1,user2) }

    before { subject }

    let(:bool1) { conv.sender == user1 || conv.sender == user2 }
    let(:bool2) { conv.recipient == user1 || conv.recipient == user2 }

    it { expect(bool1).to be_truthy }
    it { expect(bool2).to be_truthy }
  end

  describe '#most_recent_update' do
    let!(:conv) { Conversation.find_or_create!(user1,user2) }
    subject { conv.most_recent_update }

    context 'when no messages' do
      it { is_expected.to eq(conv.created_at) }
    end

    context 'when one message' do
      before { FactoryBot.create(:message, conversation_id: conv.id, sender_id: user1.id) }

      it { is_expected.to eq(conv.messages.first.created_at) }
      it { is_expected.to eq(Message.find_by_id(1).created_at) }

      context 'when two messages' do
        before { FactoryBot.create(:message, conversation_id: conv.id, sender_id: user1.id) }

        it { is_expected.to eq(conv.messages.second.created_at) }
        it { is_expected.to eq(Message.find_by_id(2).created_at) }
      end
    end
  end

  describe '#add_message(sender, message)' do
    let!(:convo) { Conversation.find_or_create!(user1,user2) }
    let(:message) { "NewMessage" }
    subject { convo.add_message(user, message) }

    context 'when valid input' do
      let(:user) { user1 }

      it { subject ; expect(convo.messages).to include(Message.first) }
    end

    context 'when opposite sender' do
      let(:user) { user2 }

      it { subject ; expect(convo.messages).to include(Message.first) }
    end
  end

  describe '#find_or_create!' do
    let(:convo) { Conversation.find_or_create!(user1, user2) }
    subject { convo }

    context 'when no pre-existing conversation' do
      before { subject }

      it { expect(convo.sender_id).to eq(user2.id) }
      it { expect(convo.recipient_id).to eq(user1.id) }
    end

    context 'when pre-existing conversation exists' do
      let!(:old_convo) { Conversation.find_or_create!(user1, user2) }

      it { subject ; expect(convo).to eq(old_convo) }
    end

    context 'when pre-existing conversation exists (flipped)' do
      let!(:old_convo) { Conversation.find_or_create!(user2, user1) }

      it { subject ; expect(convo).to eq(old_convo) }
    end

    context 'when users not unique' do
      let!(:user2) { user1 }

      it { subject ; expect(convo).to be_nil }
    end

    context 'when hard coded conversation exists' do
      let!(:old_convo) { FactoryBot.create(:conversation, sender_id: user2.id, recipient_id: user1.id) }

      it { subject ; expect(convo).to eq(old_convo) }
    end
  end

  describe 'sender/receiver' do
    subject { FactoryBot.build(:conversation, sender_id: user1.id, recipient_id: user2.id) }

    context 'when conversation is original' do
      let!(:user1) { FactoryBot.create(:user) }
      let!(:user2) { FactoryBot.create(:user) }

      it { is_expected.to be_valid }
    end

    context 'when sender and receiver are the same' do
      let!(:user1) { FactoryBot.create(:user) }
      let(:user2) { user1 }

      it { is_expected.not_to be_valid }
    end

    context 'when conversation exists between both users' do
      let!(:user1) { FactoryBot.create(:user) }
      let!(:user2) { FactoryBot.create(:user) }

      before { FactoryBot.create(:conversation, sender_id: user1.id, recipient_id: user2.id) }

      it { is_expected.not_to be_valid }
    end
  end

  describe '#mark_all_unread_messages_read!' do
    let!(:conversation) { FactoryBot.create(:conversation) }
    let!(:m1) { FactoryBot.create(:message, conversation_id: conversation.id, sender_id: conversation.sender_id, read: false) }
    let!(:m2) { FactoryBot.create(:message, conversation_id: conversation.id, sender_id: conversation.sender_id, read: false) }
    let!(:m3) { FactoryBot.create(:message, conversation_id: conversation.id, sender_id: conversation.sender_id, read: false) }

    subject { conversation.mark_all_unread_messages_read! }

    # MUST RELOAD!
    it { subject ; expect(m1.reload.read).to eq(true) }
    it { subject ; expect(m2.reload.read).to eq(true) }
    it { subject ; expect(m3.reload.read).to eq(true) }
  end
end
