FactoryBot.define do
  factory :team do
    sequence(:name) { |n| "TeamName#{n}" }
    description { "Description" }
    github_url { "StableURL" }
    created_by { create(:user).id }
  end
end