class Team < ApplicationRecord
  belongs_to :user
  has_many :members
  has_many :user_members, through: :members, source: :user
end
