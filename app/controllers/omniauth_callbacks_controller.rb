# frozen_string_literal: true

class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  rescue_from OAuth2::Error, with: :oauth_failure
  
  def google_oauth2
    begin
      member = Member.from_google(**from_google_params)
      if member.present?
        sign_out_all_scopes
        flash[:success] = t 'devise.omniauth_callbacks.success', kind: 'Google'

        sign_in_and_redirect member, event: :authentication
      else
        flash[:alert] = t 'devise.omniauth_callbacks.failure', kind: 'Google',
                                                               reason: "#{auth.info.email} is not authorized."
        redirect_to new_member_session_path
      end
    rescue => e
      oauth_failure(e)
    end
  end

  def failure
    flash[:alert] = t('devise.omniauth_callbacks.failure', kind: OmniAuth::Utils.camelize(params[:strategy] || "OAuth"),
                                                          reason: params[:message] || "authentication_error")
    redirect_to new_member_session_path
  end

  protected

  def after_omniauth_failure_path_for(_scope)
    new_member_session_path
  end

  def after_sign_in_path_for(resource_or_scope)
    if resource_or_scope.is_a?(Member) && resource_or_scope.role >= 5
      stored_location_for(resource_or_scope) || admin_path
    else
      stored_location_for(resource_or_scope) || root_path
    end
  end

  private
  
  def oauth_failure(exception)
    flash[:alert] = t 'devise.omniauth_callbacks.failure', kind: 'Google',
                                                           reason: exception.message
    redirect_to new_member_session_path
  end

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