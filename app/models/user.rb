class User < ApplicationRecord
  require 'open-uri'
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
         :trackable, :confirmable, :omniauthable, omniauth_providers: %i[facebook]
 has_many :members
 has_many :teams_member, through: :members, source: :team
 has_many :problems


 def self.from_omniauth(auth)
 where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
   user.email = auth.info.email
   user.password = Devise.friendly_token[0,20]
   user.first_name = auth.info.name  # assuming the user model has a name
   downloaded_image = open(auth.info.image)
   user.avatar.attach(io: downloaded_image, filename: 'avatar.jpg', content_type: downloaded_image.content_type)
    # assuming the user model has an image
   # If you are using confirmable and the provider(s) you use validate emails,
   # uncomment the line below to skip the confirmation emails.
   user.skip_confirmation!
 end
end
end
