FactoryBot.define do
  factory :user do
    provider { "twitter" }
    sequence(:uid) { |n| "#{n}" } 
    username { "user_1" }
    token { "asdf" }
    secret { "zxcv" }
  end
end
