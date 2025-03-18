# frozen_string_literal: true

class MemberController < ApplicationController
  before_action :restrict_non_admins, except: [:index]

  def index
    init_member_shared
  end

  def list
    @members = Member.all
    @members = @members.where('first_name ILIKE ? OR last_name ILIKE ? OR uin::text ILIKE ?', "%#{params[:query]}%", "%#{params[:query]}%", "%#{params[:query]}%") if params[:query].present?
    @members = @members.order(:email).page(params[:page]).per(20)

    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace('members-grid', partial: 'member/member_grid', locals: { members: @members })
      end
    end
  end

  def show
    @member = Member.find(params[:id])
  end

  def update
    @member = Member.find(params[:id])
    if @member.update(member_params)
      # return back
      redirect_to request.referer, notice: 'Member updated successfully.'
    else
      redirect_to request.referer, alert: 'Member could not be updated.'
    end
  end

  def search
    members = Member.search(params[:query]).limit(10).select(:id, :first_name, :last_name, :email)
    render json: members
  end

  def attendance_chart
    selected_member = Member.find(params[:member_id])
    attendance = Attendance.joins(:event)
                           .where(member_id: selected_member.id)
                           .order('events.start_time DESC')
                           .select('events.name, events.start_time, events.end_time')
    render json: attendance
  end

  def attendance_line
    filter_start_time = params[:start_time].to_datetime
    filter_end_time = params[:end_time].to_datetime
    attendance = Event.joins(:attendances)
                      .where(start_time: filter_start_time..filter_end_time)
                      .select('events.name, COUNT(attendances.id) AS attendance_count')
                      .group('events.name')
                      .order('MIN(events.start_time)')
                      .map { |e| [e.name, e.attendance_count] }
    render json: attendance
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

  def member_params
    if current_member.role >= 5
      params.require(:member).permit(:first_name, :last_name, :email, :role)
    else
      params.require(:member).permit(:first_name, :last_name, :email)
    end
  end
end
