class Commitment < ApplicationRecord
  belongs_to :user
  belongs_to :responsible, class_name: 'User'
  belongs_to :target, optional: true
  has_many :tasks
  has_many_attached :documents
  enum status: [:backlog, :waiting, :this_Week, :today, :done]
end
