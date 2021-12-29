FactoryBot.define do
  factory :invite do
    email { 'johndoe@gmail.com' }
    team_id { create(:team).id }
    sender_id { create(:user).id }
    
    # auto-assigned
    user_id { nil }
    accepted { false }
    token { nil }
  end
end