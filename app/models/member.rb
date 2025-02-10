class Member < ApplicationRecord
  devise :omniauthable, omniauth_providers: [:google_oauth2]

  def self.from_google(uid:, email:, first_name:, last_name:, avatar_url:)
    create_with(uid: uid, first_name: first_name, last_name: last_name, avatar_url: avatar_url)
      .find_or_create_by!(email: email)
  end
end
