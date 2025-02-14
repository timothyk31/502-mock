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

    context 'uniqueness validation' do
      before { Attendance.create(member: member, event: event) }

      # Test if the same member cannot attend the same event twice (uniqueness validation)
      it 'prevents duplicate attendance for the same member and event' do
        duplicate_attendance = Attendance.new(member: member, event: event)
        duplicate_attendance.valid?
        expect(duplicate_attendance.errors[:member_id]).to include('can only attend an event once')
      end

      # Test if a member can attend different events (unique constraint only applies to same event)
      it 'allows the same member to attend different events' do
        different_event = Event.create(
          name: 'Different Workshop',
          start_time: Time.current,
          end_time: Time.current + 2.hours,
          location: 'Room 102',
          attendance_code: 'CODE456'
        )
        new_attendance = Attendance.new(member: member, event: different_event)
        expect(new_attendance.valid?).to be true
      end

      # Test if different members can attend the same event (unique constraint only applies to same member)
      it 'allows different members to attend the same event' do
        different_member = Member.create(email: 'other@example.com', first_name: 'Other', last_name: 'User')
        new_attendance = Attendance.new(member: different_member, event: event)
        expect(new_attendance.valid?).to be true
      end
    end
  end

  describe 'behavior' do
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

    # Test if creating an attendance properly establishes the many-to-many relationship
    it 'creates a connection between member and event' do
      attendance = Attendance.create(member: member, event: event)
      expect(member.events).to include(event)
      expect(event.members).to include(member)
    end

    context 'when destroying attendance' do
      let!(:attendance) { Attendance.create(member: member, event: event) }

      # Test if destroying an attendance removes the connection between member and event
      it 'removes the connection between member and event' do
        attendance.destroy
        member.reload
        event.reload
        expect(member.events).not_to include(event)
        expect(event.members).not_to include(member)
      end

      # Test if destroying an attendance doesn't delete the associated member or event
      it 'does not destroy the member or event' do
        attendance.destroy
        expect { Member.find(member.id) }.not_to raise_error
        expect { Event.find(event.id) }.not_to raise_error
      end
    end
  end
end