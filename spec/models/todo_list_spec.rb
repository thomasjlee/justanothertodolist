require 'rails_helper'

RSpec.describe TodoList, type: :model do
  describe "Validations" do
    it "is valid with a title and description" do
      todo_list = TodoList.new(title:       "Coffee",
                               description: "Coffee is all we need")
      expect(todo_list).to be_valid
    end
    
    it "is not valid without a title" do
      todo_list = TodoList.new(title: nil, description: "What's my title?")
      todo_list.valid?
      expect(todo_list.errors.messages[:title]).to include "can't be blank"
    end
  end

  describe "Associations" do
    before(:context) do
      @association = described_class.reflect_on_association(:todo_items)
    end

    it "has many todo items" do
      expect(@association.macro).to eq :has_many
    end

    it "has dependent todo items" do
      expect(@association.options[:dependent]).to eq :destroy
    end
  end
end
