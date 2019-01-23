class Commitment < ApplicationRecord
  belongs_to :user
  belongs_to :responsible, class_name: 'User'
  belongs_to :target, optional: true
  has_many :tasks
  has_many_attached :documents
  enum status: [:backlog, :waiting, :this_week, :today, :expired, :closed_before_deadline, :closed_after_deadline]
end
