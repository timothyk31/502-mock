# frozen_string_literal: true

class EventsController < MemberController
  before_action :restrict_non_admins, except: %i[show index]

  def index
    super.index
    @events = @events.where('name ILIKE ? OR location ILIKE ?', "%#{params[:query]}%", "%#{params[:query]}%") if params[:query].present?
    @events = @events.order(:start_time).page(params[:page]).per(20)
  end

  def show
    @event = Event.find(params[:id])
  end

  def new
    @event = Event.new
    @event.speaker_events.build
  end

  def create
    @event = Event.new(event_params)
    # Generate random 6 digit attendance code
    @event.attendance_code = SecureRandom.random_number(1_000_000) if @event.attendance_code.nil?

    if @event.save
      Rails.logger.warn("User #{current_member.id} created event #{@event.id}")
      redirect_to @event
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @event = Event.find(params[:id])
       # @event.speaker_events.build if @event.speaker_events.empty?
  end

  def update
    @event = Event.find(params[:id])
    if @event.update(event_params)
      Rails.logger.warn("User #{current_member.id} updated event #{@event.id}")
      redirect_to events_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event = Event.find(params[:id])
    id = @event.id
    Rails.logger.warn("User #{current_member.id} deleted event #{id}")
    @event.destroy
    redirect_to events_path
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
    permitted_params = [:name, :start_time, :end_time, :location, { speaker_events_attributes: %i[id ytLink speaker_id _destroy] }]
    permitted_params << :attendance_code if current_member.role >= 5
    params.require(:event).permit(permitted_params)
  end

  def restrict_non_admins
    redirect_to root_path, alert: 'You are not authorized to make this action.' unless current_member.role >= 5
  end
end
