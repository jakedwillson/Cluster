require 'rails_helper'

RSpec.describe MessagesHelper, type: :helper do
  describe '#direct_message_link' do
    subject { helper.direct_message_link(user, current_user) }

    context 'when one parameter is non-user' do
      let!(:user) { FactoryBot.create(:user) }
      let!(:current_user) { 99 }

      it { is_expected.to eq(I18n.t('helpers.messages.errors.invalid_user')) }
    end

    context 'when sender and receiver are same' do
      let!(:user) { FactoryBot.create(:user) }
      let!(:current_user) { user }

      it { is_expected.to eq(I18n.t('helpers.messages.errors.sender_and_receiver_same')) }
    end

    context 'when parameters are valid' do
      let!(:user) { FactoryBot.create(:user) }
      let!(:current_user) { FactoryBot.create(:user) }

      it { is_expected.to eq(link_to("Direct Message", conversations_path(sender_id: current_user.id, recipient_id: user.id), method: "post")) }
    end
  end
end
