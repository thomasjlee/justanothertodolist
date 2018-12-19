require "rails_helper"

RSpec.describe TodoItem, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.build(:todo_item)).to be_valid
  end

  it "is invalid without content" do
    todo_item = FactoryBot.build(:todo_item, content: nil)
    todo_item.valid?
    expect(todo_item.errors.messages[:content]).to include "can't be blank"
  end

  it "is invalid without a todo list" do
    todo_item = FactoryBot.build(:todo_item, todo_list: nil)
    todo_item.valid?
    expect(todo_item.errors.messages[:todo_list]).to include "must exist"
  end

  it "belongs to a todo list" do
    association = described_class.reflect_on_association(:todo_list)
    expect(association.macro).to eq :belongs_to
  end

  describe "#textarea_rows" do
    it "divides content length by 60 to set textarea rows" do
      short_todo_item  = FactoryBot.build(:todo_item, content: "a" * 60)
      medium_todo_item = FactoryBot.build(:todo_item, content: "a" * 61)
      long_todo_item   = FactoryBot.build(:todo_item, content: "a" * 121)

      expect(short_todo_item.textarea_rows).to  be 1
      expect(medium_todo_item.textarea_rows).to be 2
      expect(long_todo_item.textarea_rows).to   be 3
    end
  end
end
