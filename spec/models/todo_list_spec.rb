require "rails_helper"

RSpec.describe TodoList, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.build(:todo_list)).to be_valid
  end

  it "is invalid without a title" do
    todo_list = FactoryBot.build(:todo_list, title: nil)
    todo_list.valid?
    expect(todo_list.errors[:title]).to include "can't be blank"
  end

  it "has many todo items" do
    association = described_class.reflect_on_association(:todo_items)
    expect(association.macro).to eq :has_many
  end

  it "has dependent todo items" do
    association = described_class.reflect_on_association(:todo_items)
    expect(association.options[:dependent]).to eq :destroy
  end
end
