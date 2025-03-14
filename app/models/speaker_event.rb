# frozen_string_literal: true

class SpeakerEvent < ApplicationRecord
     belongs_to :speaker
     belongs_to :event
     belongs_to :speaker_events, optional: true
end
