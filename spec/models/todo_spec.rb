require "rails_helper"

RSpec.describe Todo, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.build(:todo)).to be_valid
  end

  it "is invalid without content" do
    todo = FactoryBot.build(:todo, content: nil)
    todo.valid?
    expect(todo.errors.messages[:content]).to include "can't be blank"
  end

  it "is invalid without a list" do
    todo = FactoryBot.build(:todo, list: nil)
    todo.valid?
    expect(todo.errors.messages[:list]).to include "must exist"
  end

  it "belongs to a list" do
    association = described_class.reflect_on_association(:list)
    expect(association.macro).to eq :belongs_to
  end
end
