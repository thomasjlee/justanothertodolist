class List < ApplicationRecord
  has_many :todos, dependent: :destroy
  belongs_to :user
  validates_presence_of :title
end
