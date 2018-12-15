require 'rails_helper'

RSpec.describe TodoItem, type: :model do
  describe "Validations" do
    it "is valid with a name and todo list" do
      todo_list = FactoryBot.build(:todo_list)
      todo_item = TodoItem.new(name: "Boil the water", todo_list: todo_list)
      expect(todo_item).to be_valid
    end

    it "is not valid without a name" do
      todo_item = TodoItem.new(name: nil)
      todo_item.valid?
      expect(todo_item.errors.messages[:name]).to include "can't be blank"
    end

    it "is not valid without a todo list" do
      todo_item = TodoItem.new(name: "Boil the water")
      todo_item.valid?
      expect(todo_item.errors.messages[:todo_list]).to include "must exist"
    end
  end

  describe "Associations" do
    it "belongs to a todo list" do
      association = described_class.reflect_on_association(:todo_list)
      expect(association.macro).to eq :belongs_to
    end
  end
end
