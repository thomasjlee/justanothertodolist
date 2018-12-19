class TodoItem < ApplicationRecord
  belongs_to :todo_list
  validates_presence_of :content

  def textarea_rows
    (content.length.to_f / 60).ceil
  end
end
