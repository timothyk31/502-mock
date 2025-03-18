require 'rails_helper'

RSpec.describe SpeakerEvent, type: :model do

  let(:valid_speaker_attributes) do
    { name: "John Doe", email: "john@example.com", details: "Tech Speaker" }
  end

  let(:valid_event_attributes) do
    { 
      name: "Tech Conference", 
      start_time: DateTime.now, 
      end_time: DateTime.now + 1.hour, 
      location: "Virtual", 
      attendance_code: "CODE123" 
    }
  end

  
  let!(:speaker) { Speaker.create!(valid_speaker_attributes) }
  let!(:event) { Event.create!(valid_event_attributes) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      speaker_event = SpeakerEvent.new(speaker: speaker, event: event)
      expect(speaker_event).to be_valid
    end

    it 'is not valid without a speaker' do
      speaker_event = SpeakerEvent.new(speaker: nil, event: event)
      expect(speaker_event).not_to be_valid
      expect(speaker_event.errors[:speaker]).to include("must exist")
    end

    it 'is not valid without an event' do
      speaker_event = SpeakerEvent.new(speaker: speaker, event: nil)
      expect(speaker_event).not_to be_valid
      expect(speaker_event.errors[:event]).to include("must exist")
    end
  end

  describe 'associations' do
    it 'belongs to a speaker' do
      association = described_class.reflect_on_association(:speaker)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'belongs to an event' do
      association = described_class.reflect_on_association(:event)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'belongs to speaker_events (optional)' do
      association = described_class.reflect_on_association(:speaker_events)
      expect(association.macro).to eq(:belongs_to)
      expect(association.options[:optional]).to be(true)
    end
  end
end