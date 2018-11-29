module TodoListsHelper
  def any_completed?(todo_items)
    todo_items.any? { |item| item.completed? }
  end
end
