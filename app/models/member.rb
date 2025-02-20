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

  def admin?
    role >= 5
  end

  def self.non_attendees_for(event_id)
    where.not(id: Attendance.for_event(event_id).pluck(:member_id))
  end

  def self.from_google(uid:, email:, first_name:, last_name:, avatar_url:)
    create_with(uid: uid, first_name: first_name, last_name: last_name, avatar_url: avatar_url)
      .find_or_create_by!(email: email)
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

    case role
    when 'unapproved_member'
      'Unapproved Member'
    when 'member'
      'Member'
    when 'unknown2'
      'Unknown 2'
    when 'unknown3'
      'Unknown 3'
    when 'unknown4'
      'Unknown 4'
    when 'administrator'
      'Administrator'
    end
  end
end
