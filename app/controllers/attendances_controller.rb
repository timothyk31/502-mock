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
      Rails.logger.warn("User #{current_member.id} updated attendance #{@attendance.id}")
      redirect_to @attendance, notice: 'Attendance was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    id = @attendance.id
    @attendance.destroy
    Rails.logger.warn("User #{current_member.id} deleted attendance #{id}")
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

  def non_attendees
    event = Event.find(params[:event_id])
    @non_attendees = Member.non_attendees_for(event.id)

    respond_to do |format|
      format.csv do
        send_data generate_csv(@non_attendees),
                  filename: "non-attendees-event-#{event.id}-#{Time.zone.today}.csv"
      end
    end
  end

  private

  def generate_csv(members)
    CSV.generate(headers: true) do |csv|
      csv << ['ID', 'First Name', 'Last Name', 'Email', 'UIN', 'Class Year', 'Role', 'Phone Number', 'Address', 'Joined At']
      members.each do |member|
        csv << [
             member.id,
             member.first_name,
             member.last_name,
             member.email,
             member.uin,
             member.class_year,
             member.role,
             member.phone_number,
             member.address,
             member.created_at
        ]
      end
    end
  end

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
