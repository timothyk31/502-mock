class SpeakerEventsController < ApplicationController
     before_action :set_speakerevent, only: %i[edit update destroy]

     def new
          @speakerevent = Speakerevent.new
     end

     def edit
     end

     def create
          @speakerevent = Speakerevent.new(speakerevent_params)
          if @speakerevent.save
               redirect_to speaker_events_path, notice: 'Event was successfully created.'
          else
               render :new, status: :unprocessable_entity
          end
     end

     def update
          if @speakerevent.update(speakerevent_params)
               redirect_to speaker_events_path, notice: 'Event was successfully updated.'
          else
               render :edit, status: :unprocessable_entity
          end
     end

     def destroy
          @speakerevent.destroy
          redirect_to speaker_events_url, notice: 'Event was successfully destroyed.'
     end

     private

     def set_speakerevent
          @speakerevent = Speakerevent.find(params[:id])
     end

     def speakerevent_params
          params.require(:speakerevent).permit(:event, :ytLink, :speaker)
     end
end
