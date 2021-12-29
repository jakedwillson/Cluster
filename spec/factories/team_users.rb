FactoryBot.define do
  factory :team_user do
    team_id { create(:team).id }
    user_id { create(:user).id }
  end
end
