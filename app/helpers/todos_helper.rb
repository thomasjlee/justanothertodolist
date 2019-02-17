module TodosHelper
  def is_editing_todo?(todo)
    params[:action] == "edit" && todo.id.to_s == params[:id]
  end
end
