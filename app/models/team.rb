class Team < ApplicationRecord
  belongs_to :user
  has_many :members, dependent: :delete_all
  has_many :targets, dependent: :nullify
  has_many :user_members, through: :members, source: :user
end
