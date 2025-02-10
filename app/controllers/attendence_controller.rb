class AttendancesController < ApplicationController
  before_action :set_attendance, only: %i[show edit update destroy]
  before_action :restrict_non_admins, except: %i[index show]

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

  def edit
  end

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

  private

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
