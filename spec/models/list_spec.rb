require "rails_helper"

RSpec.describe List, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.build(:list)).to be_valid
  end

  it "is invalid without a title" do
    list = FactoryBot.build(:list, title: nil)
    list.valid?
    expect(list.errors[:title]).to include "can't be blank"
  end

  it "has many todos" do
    association = described_class.reflect_on_association(:todos)
    expect(association.macro).to eq :has_many
  end

  it "has dependent todos" do
    association = described_class.reflect_on_association(:todos)
    expect(association.options[:dependent]).to eq :destroy
  end
end
