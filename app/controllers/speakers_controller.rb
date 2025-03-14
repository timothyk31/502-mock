# frozen_string_literal: true

class SpeakersController < ApplicationController
  before_action :authenticate_speaker!
  before_action :set_speaker, only: %i[show edit update destroy]

  def index
    @speakers = Speaker.all
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
      redirect_to speakers_path, notice: 'Speaker was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @speaker.update(speaker_params)
      redirect_to speakers_path, notice: 'Speaker was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @speaker.destroy
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
