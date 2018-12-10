FactoryBot.define do
  factory :todo_item do
    name { "First, boil the water." }
    todo_list
  end
end

