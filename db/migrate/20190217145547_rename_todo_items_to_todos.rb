class RenameTodoItemsToTodos < ActiveRecord::Migration[5.2]
  def change
    rename_table :todo_items, :todos
  end
end
