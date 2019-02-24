FactoryBot.define do
  factory :list do
    title { "Coffee" }
    description { "Coffee is all we need" }
    user
  end
end
