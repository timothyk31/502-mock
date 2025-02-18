# frozen_string_literal: true

class SpeakersController < ApplicationController
  before_action :authenticate_speaker!
  def index
    @speakers = Speaker.all # Assuming you have a Speaker model
  end

  def show
    @speaker = Speaker.find(params[:id]) # For showing individual speaker
  end

  def authenticate_speaker!
    redirect_to root_path, alert: 'Access denied.' unless current_member.role >= 1
  end
end
