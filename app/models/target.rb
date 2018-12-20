class Target < ApplicationRecord
  belongs_to :team, optional: true
  belongs_to :user
  belongs_to :responsible, class_name: 'User', optional:true
  has_many :commitments
end
