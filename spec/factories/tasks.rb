FactoryBot.define do
  factory :task do
    sequence(:name) { |n| "MyTask#{n}" }
    note { "MyNote" }
    deadline { nil }
    github_url { nil }
    status { nil }
    user_status { nil }
    user_id { create(:user).id }
    team_id { create(:team).id }
  end
end
