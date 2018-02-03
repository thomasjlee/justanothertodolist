3.times do |i|
  TodoList.create!(
    name: "todo_list_#{i}",
    description: "description of the todo list",
    status: 0
  )
end
