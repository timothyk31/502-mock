# frozen_string_literal: true

class MemberController < ApplicationController
  before_action :restrict_non_admins, except: [:index]

  def index
    init_member_shared
  end

  def show
    @member = Member.find(params[:id])
  end

  def new
    @member = Member.new
  end

  def create
    @member = Member.new(member_params)
    if @member.save
      redirect_to @member
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @member = Member.find(params[:id])
  end

  def update
    @member = Member.find(params[:id])
    if @member.update(member_params)
      redirect_to @member
    else
      render :edit
    end
  end

  def destroy
    @member = Member.find(params[:id])
    @member.destroy

    redirect_to members_path
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

  def member_params
    params.require(:member).permit(:email, :first_name, :last_name, :uid, :avatar_url, :class_year, :role, :phone_number, :address, :uin)

  def restrict_non_admins
    redirect_to root_path, alert: 'You are not authorized to view this page.' unless current_member.role >= 5
  end
end
end
