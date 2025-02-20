# frozen_string_literal: true

class EventsController < MemberController
  before_action :restrict_non_admins, except: %i[show index]

  def index
    super.index
  end

  def show
    @event = Event.find(params[:id])
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    # Generate random 6 digit attendance code
    @event.attendance_code = SecureRandom.random_number(1_000_000) if @event.attendance_code.nil?

    if @event.save
      redirect_to @event
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    if @event.update(event_params)
      redirect_to @event
    else
      render :edit
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    redirect_to admin_path
  end

  def attendance_chart
    selected_event = Event.find(params[:event_id])
    members = selected_event.attendances.joins(:member).select('members.first_name, members.last_name, members.email, members.uin')
    render json: {
      event: { name: selected_event.name, start_time: selected_event.start_time,
               end_time: selected_event.end_time }, members: members
    }
  end

  def search
    events = Event.search(params[:query]).limit(10).select(:id, :name, :start_time, :end_time)
    render json: events
  end

  def popular_events
    start_time = params[:start_time].to_datetime
    end_time = params[:end_time].to_datetime
    events = Event.joins(:attendances)
                  .where(start_time: start_time..end_time)
                  .select('events.name, COUNT(attendances.id) AS attendance_count')
                  .group('events.name')
                  .order('attendance_count DESC')
                  .limit(10)
                  .map { |e| [e.name, e.attendance_count] }
    render json: events
  end

  private

  def event_params
    permitted_params = %i[name start_time end_time location]
    permitted_params << :attendance_code if current_member.role >= 5
    params.require(:event).permit(permitted_params)
  end

  def restrict_non_admins
    redirect_to root_path, alert: 'You are not authorized to make this action.' unless current_member.role >= 5
  end
end
