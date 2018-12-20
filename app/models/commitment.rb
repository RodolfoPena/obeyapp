class Commitment < ApplicationRecord
  belongs_to :user
  belongs_to :responsible, class_name: 'User'
  belongs_to :target, optional: true
end
