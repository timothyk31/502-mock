class Speaker < ApplicationRecord
    validates :name, presence: true
    validates :details, presence: true
    validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  end