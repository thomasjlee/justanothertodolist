class CreateTodoLists < ActiveRecord::Migration[5.1]
  def change
    create_table :todo_lists do |t|
      t.string :name
      t.text :description
      t.time :due_date
      t.integer :status

      t.timestamps
    end
  end
end
