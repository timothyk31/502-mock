class MemberController < ApplicationController
  before_action :restrict_non_admins, except: [:index]

  def index
    # Members can only see themselves
    @member = current_member
  end

  def show
    @member = Member.find(params[:id])
  end

  private

  def restrict_non_admins
    redirect_to root_path, alert: 'You are not authorized to view this page.' unless current_member.role >= 5
  end
end
