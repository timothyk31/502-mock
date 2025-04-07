# frozen_string_literal: true

class Member < ApplicationRecord
  devise :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :attendances
  has_many :events, through: :attendances

  # TODO: MIGRATE TO THIS LATER
  # enum role: {
  #   unapproved_member: 0,
  #   member: 1,
  #   unknown2: 2,
  #   unknown3: 3,
  #   unknown4: 4,
  #   administrator: 5
  # }

  paginates_per 20

  # Validations
  validates :class_year, numericality: { less_than: 9999 }, allow_nil: true
  validates :phone_number, format: { with: /\A\d{10}\z/, message: 'must be a 10-digit number (sorry international students))' }, allow_nil: true
  validates :uin, format: { with: /\A\d{9}\z/, message: 'must be a 9-digit number' }, allow_nil: true

  def admin?
    role >= 5
  end

  def self.non_attendees_for(event_id)
    where.not(id: Attendance.for_event(event_id).pluck(:member_id))
  end

  def self.from_google(uid:, email:, first_name:, last_name:, avatar_url:)
    member = find_or_initialize_by(email: email)

    # Update attributes
    member.uid = uid
    member.first_name = first_name
    member.last_name = last_name
    member.avatar_url = avatar_url

    # Set default values for required fields if this is a new record
    if member.new_record?
      member.class_year ||= 0
      member.role ||= 0
    end

    member.save!
    member
  end

  def self.search(query)
    if query.present?
      where('first_name ILIKE ? OR last_name ILIKE ? OR email ILIKE ?', "%#{query}%", "%#{query}%", "%#{query}%")
    else
      all
    end
  end

  def role_name
    return 'Developer' if ENV['DEV_EMAIL'] == email

    # case role
    # when 'unapproved_member'
    #   'Unapproved Member'
    # when 'member'
    #   'Member'
    # when 'unknown2'
    #   'Unknown 2'
    # when 'unknown3'
    #   'Unknown 3'
    # when 'unknown4'
    #   'Unknown 4'
    # when 'administrator'
    #   'Administrator'
    # end
    case role
    when 0
      'Unapproved Member'
    when 1
      'Member'
    when 2
      'Unknown 2'
    when 3
      'Unknown 3'
    when 4
      'Unknown 4'
    when 5
      'Administrator'
    end
  end
end
