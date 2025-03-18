require 'rails_helper'

RSpec.describe "OmniauthCallbacks", type: :routing do
  it "routes to omniauth_callbacks#google_oauth2" do
    expect(get: '/members/auth/google_oauth2/callback')
      .to route_to(controller: 'omniauth_callbacks', action: 'google_oauth2')
  end
end