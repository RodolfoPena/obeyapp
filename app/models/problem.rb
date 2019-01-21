class Problem < ApplicationRecord
  belongs_to :target, optional: true
  has_many :causes
  accepts_nested_attributes_for :causes
  belongs_to :user
end
