# frozen_string_literal: true

class AttendancesController < MemberController
  before_action :set_attendance, only: %i[show edit update destroy]
  before_action :restrict_non_admins, except: %i[index show verify]

  def show
    # if the user is not an admin, they can only see their own attendance
    return unless current_member.role < 5

    return if @attendance.member_id == current_member.id

    redirect_to root_path,
                alert: 'You are not authorized to view this page.'
  end

  def new
    @attendance = Attendance.new
  end

  def create
    @attendance = Attendance.new(attendance_params)
    if @attendance.save
      redirect_to @attendance, notice: 'Attendance was successfully created.'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @attendance.update(attendance_params)
      redirect_to @attendance, notice: 'Attendance was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @attendance.destroy
    redirect_to attendances_url, notice: 'Attendance was successfully destroyed.'
  end

  def verify
    event = find_event
    if valid_attendance_code?(event)
      create_attendance(event)
    else
      redirect_to request.referer, alert: 'Invalid or missing attendance code or event has ended.'
    end
  end

  private

  def find_event
    Event.find(params[:event_id])
  end

  def valid_attendance_code?(event)
    event.attendance_code.present? &&
      event.attendance_code == params[:attendance_code] &&
      Time.now >= event.start_time &&
      (event.end_time.nil? || Time.now <= event.end_time)
  end

  def create_attendance(event)
    @attendance = Attendance.new(member: current_member, event: event)
    if @attendance.save
      redirect_to request.referer, notice: 'Attendance was successfully created.'
    else
      redirect_to request.referer, alert: 'Failed to create attendance.'
    end
  end

  def set_attendance
    @attendance = Attendance.find(params[:id])
  end

  def attendance_params
    params.require(:attendance).permit(:member_id, :event_id, :status)
  end

  def restrict_non_admins
    redirect_to root_path, alert: 'You are not authorized to make this action.' unless current_member.role >= 5
  end
end
