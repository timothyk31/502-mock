# frozen_string_literal: true

class SpeakersController < ApplicationController
  before_action :authenticate_speaker!
  def index
    @speakers = Speaker.all # Assuming you have a Speaker model
  end

  def show
    @speaker = Speaker.find(params[:id]) # For showing individual speaker
  end

  def new
    @speaker = Speaker.new
  end
  
  def create
    @speaker = Speaker.new(speaker_params)
    if @speaker.save
      redirect_to @speaker
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @speaker = Speaker.find(params[:id])
  end

  def update
    @speaker = Speaker.find(params[:id])
    if @speaker.update(speaker_params)
      redirect_to @speaker
    else
      render :edit
    end
  end

  def destroy
    @speaker = Speaker.find(params[:id])
    @speaker.destroy

    redirect_to admin_path
  end

  def search
    members = Member.search(params[:query]).limit(10).select(:id, :first_name, :last_name, :email)
    render json: members
  end

  def authenticate_speaker!
    redirect_to root_path, alert: 'Access denied.' unless current_member.role >= 1
  end

  private
  def speaker_params
    permitted_params = %i[name details email]
    params.require(:speaker).permit(permitted_params)
  end

  def restrict_non_admins
    redirect_to root_path, alert: 'You are not authorized to make this action.' unless current_member.role >= 5
  end
end
