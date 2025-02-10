class AdminController < MemberController
  before_action :authenticate_admin!

  def index
    @members = Member.all
    @current_user = current_member
  end

  private

  def authenticate_admin!
    redirect_to root_path, alert: 'Access denied.' unless current_member.role == 5
  end
end
