class User < ApplicationRecord
  validates :provider,
    presence: true,
    inclusion: {
      in: ["twitter", "github"],
      message: "Twitter and Github are the only acceptable auth providers"
    }
  validates :uid,      presence: true, uniqueness: true
  validates :username, presence: true
  validates :token,    presence: true
  validates :secret,   presence: true

  has_many :lists
end
