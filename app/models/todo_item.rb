class TodoItem < ApplicationRecord
  belongs_to :todo_list
  validates_presence_of :content
end
