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
end
