class Event < ApplicationRecord
  has_many :attendances
  has_many :members, through: :attendances

  validates :name, presence: true
  validates :date, presence: true
end
