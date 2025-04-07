# frozen_string_literal: true

class AdminController < MemberController
  before_action :authenticate_admin!

  def index
    init_member_shared
    @members = Member.all
  end

  def update_roles
    params[:members].each do |id, role|
      member = Member.find(id)
      member.update(role: role)
    end
    Rails.logger.warn("Member #{member.role}'s role updated by #{current_member.id}")
    redirect_to admin_path, notice: 'Roles updated successfully.'
  end

  private

  def authenticate_admin!
    redirect_to root_path, alert: 'Access denied.' unless current_member.role >= 5
  end
end
