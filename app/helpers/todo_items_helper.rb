module TodoItemsHelper
  def is_editing_todo?(todo_item)
    params[:action] == "edit" && todo_item.id.to_s == params[:id]
  end
end
