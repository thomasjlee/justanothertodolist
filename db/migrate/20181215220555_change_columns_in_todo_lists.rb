class ChangeColumnsInTodoLists < ActiveRecord::Migration[5.2]
  def change
    remove_column :todo_lists, :status, :integer
    rename_column :todo_lists, :name, :title
    change_column_null :todo_lists, :title, false
  end
end
