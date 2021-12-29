FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "FirstLast#{n}" }
    first_name { "First" }
    last_name { "Last" }
    sequence(:email) { |n| "firstlast#{n}@domain.com" }
    password { "MyPassword" }
    confirmed_at { Date.today }
  end
end