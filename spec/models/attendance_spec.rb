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
end