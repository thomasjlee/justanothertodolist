class TodoItem < ApplicationRecord
  belongs_to :list
  validates_presence_of :content
  before_save :trim

  # Max one line break between lines, one space between words, and no whitespace around
  def trim
    self.content = self.content.squeeze("\n").squeeze(" ").strip
  end
end
