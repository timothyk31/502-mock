require 'rails_helper'

RSpec.describe Attendance, type: :model do
  describe 'associations' do
    # Test if Attendance model correctly sets up belongs_to association with Member
    it 'belongs to a member' do
      association = Attendance.reflect_on_association(:member)
      expect(association.macro).to eq :belongs_to
    end

    # Test if Attendance model correctly sets up belongs_to association with Event
    it 'belongs to an event' do
      association = Attendance.reflect_on_association(:event)
      expect(association.macro).to eq :belongs_to
    end
  end

  describe 'validations' do
    let(:member) { Member.create(email: 'test@example.com', first_name: 'Test', last_name: 'User') }
    let(:event) do 
      Event.create(
        name: 'Ruby Workshop',
        start_time: Time.current,
        end_time: Time.current + 2.hours,
        location: 'Room 101',
        attendance_code: 'CODE123'
      )
    end

    context 'when creating a new attendance' do
      # Test if an attendance record can be created with valid member and event
      it 'is valid with valid attributes' do
        attendance = Attendance.new(member: member, event: event)
        expect(attendance.valid?).to be true
      end

      # Test if attendance is invalid when member is not provided (member_id presence validation)
      it 'is invalid without a member' do
        attendance = Attendance.new(event: event)
        attendance.valid?
        expect(attendance.errors[:member_id]).to include("can't be blank")
      end

      # Test if attendance is invalid when event is not provided (event_id presence validation)
      it 'is invalid without an event' do
        attendance = Attendance.new(member: member)
        attendance.valid?
        expect(attendance.errors[:event_id]).to include("can't be blank")
      end
    end  
  end
end