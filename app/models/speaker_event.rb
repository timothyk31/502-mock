# frozen_string_literal: true

class SpeakerEvent < ApplicationRecord
     belongs_to :speaker
     belongs_to :event
     belongs_to :speaker_events, optional: true

     def convert_link_to_embed
          if ytLink.include?('youtube.com/watch?v=')
               video_id = ytLink.split('v=').last
               "https://www.youtube.com/embed/#{video_id}"
          elsif ytLink.include?('youtu.be/')
               video_id = ytLink.split('/').last.split('?').first
               "https://www.youtube.com/embed/#{video_id}"
          else
               'Invalid URL'
          end
     end
end
