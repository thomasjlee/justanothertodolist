class AddUserIdToLists < ActiveRecord::Migration[5.2]
  def change
    add_reference :lists,
      :user,
      foreign_key: true,
      null: false
  end
end
