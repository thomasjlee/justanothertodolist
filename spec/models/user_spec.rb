require "rails_helper"

RSpec.describe User, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.build(:user)).to be_valid
  end

  it "is invalid without a provider" do
    user = FactoryBot.build(:user, provider: nil)
    user.valid?
    expect(user.errors[:provider]).to include "can't be blank"
  end

  it "is invalid with a provider that is not twitter or github" do
    user = FactoryBot.build(:user, provider: "google")
    user.valid?
    expect(user.errors[:provider]).to include "Twitter and Github are the only acceptable auth providers"
  end

  it "is invalid without a uid" do
    user = FactoryBot.build(:user, uid: nil)
    user.valid?
    expect(user.errors[:uid]).to include "can't be blank"
  end

  it "cannot have a duplicate uid" do
    user = FactoryBot.create(:user)
    duplicate_user = FactoryBot.build(:user, uid: user.uid)
    duplicate_user.valid?
    expect(duplicate_user.errors[:uid]).to include "has already been taken"
  end

  it "is invalid without a username" do
    user = FactoryBot.build(:user, username: nil)
    user.valid?
    expect(user.errors[:username]).to include "can't be blank"
  end

  it "is invalid without a token" do
    user = FactoryBot.build(:user, token: nil)
    user.valid?
    expect(user.errors[:token]).to include "can't be blank"
  end

  it "is invalid without a secret" do
    user = FactoryBot.build(:user, secret: nil)
    user.valid?
    expect(user.errors[:secret]).to include "can't be blank"
  end

  xit "has many lists" do
    association = described_class.reflect_on_association(:lists)
    expect(association.macro).to eq :has_many
  end

  xit "has dependent lists" do
    association = described_class.reflect_on_association(:lists)
    expect(association.options[:dependent]).to eq :destroy
  end
end
