require 'rails_helper'

RSpec.describe ConversationsHelper, type: :helper do
  let!(:user1) { FactoryBot.create(:user) }
  let!(:user2) { FactoryBot.create(:user) }
  let!(:user3) { FactoryBot.create(:user) }
  let!(:user4) { FactoryBot.create(:user) }

  describe '#user_initials' do

    subject { helper.user_initials(user) }

    context 'when user has first and last name' do
      let!(:user) { FactoryBot.create(:user, first_name: "John", last_name: "Doe", username: "JohnDoe") }

      it { is_expected.to eq("JO") }
    end

    context 'when user only has username' do
      let!(:user) { FactoryBot.create(:user, first_name: nil, last_name: nil, username: "William") }

      it { is_expected.to eq("WI") }
    end

  end

  describe '#newest_conversations_first' do
    let(:list) { helper.newest_conversations_first(user1) }
    subject { list }

    context 'when no conversations' do
      it { is_expected.to eq([]) }
    end

    context 'when one conversation exists' do
      let!(:c1) { Conversation.find_or_create!(user1,user2) }

      context 'when no messages exist' do
        it { is_expected.to eq([]) }
      end

      context 'when messages exist' do
        let!(:m1) { c1.add_message(user1, "message") }

        it { is_expected.to eq([c1]) }
      end
    end

    context 'when two conversations exists' do
      let!(:c1) { Conversation.find_or_create!(user1,user2) }
      let!(:c2) { Conversation.find_or_create!(user1,user3) }

      context 'when no messages exist' do
        it { is_expected.to eq([]) }
      end

      context 'when 1 convo has messages' do
        let!(:m1) { c1.add_message(user1, "message") }

        it { is_expected.to eq([c1]) }
      end

      context 'when both convos have messages' do
        let!(:m1) { c1.add_message(user1, "message") }
        let!(:m2) { c2.add_message(user1, "message") } # latest one

        it { is_expected.to eq([c2,c1]) }
      end
    end

    context 'when 3 convos exist' do
      let!(:c1) { Conversation.find_or_create!(user1,user2) }
      let!(:c2) { Conversation.find_or_create!(user1,user3) }
      let!(:c3) { Conversation.find_or_create!(user1,user4) }

      let!(:m1) { c1.add_message(user1, "message") }
      let!(:m2) { c2.add_message(user1, "message") }
      let!(:m3) { c3.add_message(user1, "message") }

      it { is_expected.to eq([c3,c2,c1]) }
    end
  end
end
