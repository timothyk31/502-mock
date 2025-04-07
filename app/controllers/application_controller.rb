# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_member!
  before_action :redirect_if_member_info_missing, unless: -> { request.path == register_path || request.path == member_path(current_member.id) }

     private

  def redirect_if_member_info_missing
    return unless current_member.uin.blank? || current_member.phone_number.blank? || current_member.class_year.blank?

    redirect_to register_path, alert: 'Please complete your registration.'
  end
end
