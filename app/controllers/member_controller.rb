class MemberController < ApplicationController
  before_action :restrict_non_admins, except: [:index]

  def index
    init_member_shared
  end

  def show
    @member = Member.find(params[:id])
  end

  protected

  def init_member_shared
    @member = current_member
    @events = if params[:filter] == 'past'
                Event.where('end_time < ?', Time.now).order(start_time: :asc)
              else
                Event.where('start_time >= ?', Time.now).order(start_time: :asc)
              end
    @current_events = Event.where('start_time <= ? AND end_time >= ?', Time.now, Time.now).order(start_time: :asc)
  end

  private

  def restrict_non_admins
    redirect_to root_path, alert: 'You are not authorized to view this page.' unless current_member.role >= 5
  end
end
