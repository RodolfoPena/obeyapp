class User < ApplicationRecord
  has_one_attached :avatar
  has_many :teams
  has_many :targets
  # Relationship between the user and commitment models
  has_many :owner_commitments, class_name: 'Commitment', :foreign_key => 'user_id'
  has_many :responsible_commitments, class_name: 'Commitment', :foreign_key => 'responsible_id'
  # Relationship between the user and target models
  has_many :owner_targets, class_name: 'Target', :foreign_key => 'user_id'
  has_many :responsible_targets, class_name: 'Target', :foreign_key => 'responsible_id'
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, :confirmable
   has_many :members
   has_many :teams_member, through: :members, source: :team
   has_many :problems

end
