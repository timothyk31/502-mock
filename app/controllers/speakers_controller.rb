class SpeakersController < ApplicationController
    def index
      @speakers = Speaker.all  # Assuming you have a Speaker model
    end
  
    def show
      @speaker = Speaker.find(params[:id])  # For showing individual speaker
    end
  end