class ChangeAssociationInTodoItems < ActiveRecord::Migration[5.2]
  def change
    rename_column :todo_items, :todo_list_id, :list_id
  end
end
