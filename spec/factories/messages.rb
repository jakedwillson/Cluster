FactoryBot.define do
  factory :message do
    conversation_id { create(:conversation).id }
    sender_id { create(:user).id }
    read { false }
    sequence(:body) { |n| "this is my message#{n}" }
  end
end