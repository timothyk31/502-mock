# frozen_string_literal: true

class SpeakersController < ApplicationController
  before_action :authenticate_speaker!
  before_action :set_speaker, only: %i[show edit update destroy]

  def index
    @speakers = Speaker.all
    @speakers = @speakers.where('name ILIKE ? OR email ILIKE ?', "%#{params[:query]}%", "%#{params[:query]}%") if params[:query].present?
    @speakers = @speakers.order(:name).page(params[:page]).per(20)
  end

  def show
    redirect_to speakers_path
  end

  def new
    @speaker = Speaker.new
  end

  def edit
  end

  def create
    @speaker = Speaker.new(speaker_params)
    if @speaker.save
      Rails.logger.warn("User #{current_member.id} created speaker #{@speaker.id}")
      redirect_to speakers_path, notice: 'Speaker was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @speaker.update(speaker_params)
      Rails.logger.warn("User #{current_member.id} updated speaker #{@speaker.id}")
      redirect_to speakers_path, notice: 'Speaker was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    id = @speaker.id
    @speaker.destroy
    Rails.logger.warn("User #{current_member.id} deleted speaker #{id}")
    redirect_to speakers_url, notice: 'Speaker was successfully destroyed.'
  end

     private

  def set_speaker
    @speaker = Speaker.find(params[:id])
  end

  def speaker_params
    params.require(:speaker).permit(:name, :email, :details, speaker_events_attributes: %i[id event_name ytlink _destroy])
  end

  def authenticate_speaker!
    redirect_to root_path, alert: 'Access denied.' unless current_member.role >= 1
  end
end
