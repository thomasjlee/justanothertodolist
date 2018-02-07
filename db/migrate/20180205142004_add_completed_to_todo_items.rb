class AddCompletedToTodoItems < ActiveRecord::Migration[5.1]
  def change
    remove_column :todo_items, :completed
    add_column :todo_items, :completed, :boolean, default: false
  end
end
