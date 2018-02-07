class RemoveDueDateFromTodoItemsAndTodoLists < ActiveRecord::Migration[5.1]
  def change
    remove_column :todo_items, :due_date
    remove_column :todo_lists, :due_date
  end
end
