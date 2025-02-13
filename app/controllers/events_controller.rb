# frozen_string_literal: true

class EventsController < MemberController
  before_action :restrict_non_admins, except: %i[show]

  def show
    @event = Event.find(params[:id])
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    # Generate random 6 digit include letters and numbers for attendance code
    @event.attendance_code = SecureRandom.alphanumeric(6)

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
