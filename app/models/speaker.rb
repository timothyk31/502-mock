# frozen_string_literal: true

class Speaker < ApplicationRecord
  has_many :speaker_events, dependent: :destroy
  # accepts_nested_attributes_for :speaker_events, allow_destroy: true
  validates :name, presence: true
  validates :details, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
