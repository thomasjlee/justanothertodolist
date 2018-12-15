class RenameColumnInTodoItems < ActiveRecord::Migration[5.2]
  def change
    rename_column :todo_items, :name, :content
  end
end
