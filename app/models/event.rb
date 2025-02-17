# frozen_string_literal: true

class Event < ApplicationRecord
  has_many :attendances, dependent: :destroy
  has_many :members, through: :attendances

  validates :name, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :location, presence: true
  validates :attendance_code, presence: true

  validate :end_time_after_start_time

  private

  def end_time_after_start_time
    return if end_time.blank? || start_time.blank?

    return unless end_time < start_time

    errors.add(:end_time, 'must be after the start time')
  end

  def self.search(query)
    if query.present?
      where('name ILIKE ?', "%#{query}%")
    else
      all
    end
  end
end
