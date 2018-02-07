class TodoList < ApplicationRecord
  has_many :todo_items, dependent: :destroy
  validates_presence_of :name
end
