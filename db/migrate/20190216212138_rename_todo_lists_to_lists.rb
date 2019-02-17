class RenameTodoListsToLists < ActiveRecord::Migration[5.2]
  def change
    rename_table :todo_lists, :lists
  end
end
