class User < ApplicationRecord
  has_one_attached :avatar
  has_many :teams
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, :confirmable
   has_many :members
   has_many :teams_member, through: :members, source: :team
end
