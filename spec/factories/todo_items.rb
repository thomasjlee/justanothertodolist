FactoryBot.define do
  factory :todo_item do
    content { "First, boil the water." }
    todo_list
  end
end

