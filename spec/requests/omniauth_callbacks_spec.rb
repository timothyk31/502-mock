# spec/controllers/omniauth_callbacks_controller_spec.rb
require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:member]
  end

  describe "GET #google_oauth2" do
    context "with valid credentials" do
      let(:auth_hash) do
        OmniAuth::AuthHash.new({
          provider: 'google_oauth2',
          uid: '123456',
          info: {
            email: 'test@example.com',
            first_name: 'John',
            last_name: 'Doe',
            image: 'http://example.com/avatar.jpg'
          }
        })
      end

      before do
        # Mock the auth hash directly in the controller
        request.env["omniauth.auth"] = auth_hash
      end

      it "creates a member with google attributes" do
        expect {
          get :google_oauth2
        }.to change(Member, :count).by(1)

        member = Member.last
        expect(member.uid).to eq('123456')
        expect(member.email).to eq('test@example.com')
        expect(member.first_name).to eq('John')
        expect(member.last_name).to eq('Doe')
        expect(member.avatar_url).to eq('http://example.com/avatar.jpg')
      end

      it "updates existing member by email" do
        existing_member = Member.create!(
          email: 'test@example.com',
          uid: 'old_uid',
          first_name: 'Old',
          last_name: 'Name',
          avatar_url: 'old_avatar.jpg',
          class_year: 0,
          role: 0,
          uin: "default_uin"
        )

        expect {
          get :google_oauth2
        }.not_to change(Member, :count)

        existing_member.reload
        expect(existing_member.uid).to eq('123456')
        expect(existing_member.first_name).to eq('John')
        expect(existing_member.last_name).to eq('Doe')
        expect(existing_member.avatar_url).to eq('http://example.com/avatar.jpg')
      end
    end

    context "with invalid credentials" do
      before do
        # For the failure scenario
        @request.env["omniauth.auth"] = nil
        allow(controller).to receive(:from_google_params).and_raise(OAuth2::Error.new(nil))
      end

      it "redirects to sign-in page" do
        get :google_oauth2
        expect(response).to redirect_to(new_member_session_path)
        expect(flash[:alert]).to be_present
      end
    end
  end
end