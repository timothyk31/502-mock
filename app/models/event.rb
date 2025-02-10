class Event < ApplicationRecord
  has_many :attendances
  has_many :members, through: :attendances

  validates :name, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :location, presence: true
  validates :attendance_code, presence: true
end
