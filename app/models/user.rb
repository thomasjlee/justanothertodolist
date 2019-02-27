class User < ApplicationRecord
  validates :provider,
    presence: true,
    inclusion: {
      in: ["twitter", "github"],
      message: "Twitter and Github are the only acceptable auth providers",
    }
  validates :uid, presence: true, uniqueness: true
  validates :username, presence: true
  validates :token, presence: true
  validates :secret, presence: true

  has_many :lists, dependent: :destroy

  def self.find_or_create_from_auth_hash(auth_hash)
    user = where(provider: auth_hash[:provider], uid: auth_hash[:uid]).first_or_create
    user.update(
      username: auth_hash[:info][:nickname],
      token: auth_hash[:credentials][:token],
      secret: auth_hash[:credentials][:secret],
    )
    user
  end
end
