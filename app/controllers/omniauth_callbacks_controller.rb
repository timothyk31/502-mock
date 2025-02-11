# frozen_string_literal: true

class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    member = Member.from_google(**from_google_params)
    if member.present?
      sign_out_all_scopes
      flash[:success] = t 'devise.omniauth_callbacks.success', kind: 'Google'

      sign_in_and_redirect member, event: :authentication
    else
      flash[:alert] = t 'devise.omniauth_callbacks.failure', kind: 'Google',
                                                             reason: "#{auth.info.email} is not authorized."
      redirect_to user_new_member_session_path
    end
  end

  protected

  def after_omniauth_failure_path_for(_scope)
    user_new_member_session_path
  end

  def after_sign_in_path_for(resource_or_scope)
    if resource_or_scope.is_a?(Member) && resource_or_scope.role >= 5
      stored_location_for(resource_or_scope) || admin_path
    else
      stored_location_for(resource_or_scope) || root_path
    end
  end

  private

  def from_google_params
    @from_google_params ||= {
      uid: auth.uid,
      email: auth.info.email,
      first_name: auth.info.first_name,
      last_name: auth.info.last_name,
      avatar_url: auth.info.image
    }
  end

  def auth
    @auth ||= request.env['omniauth.auth']
  end
end
