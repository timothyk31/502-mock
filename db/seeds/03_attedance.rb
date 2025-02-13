require 'faker'

# Generate sample attendances
events = Event.all
members = Member.all

events.each do |event|
  # Delete all current attendances for this event
  Attendance.where(event_id: event.id).destroy_all

  # Randomly select a subset of members to attend this event
  members.sample(rand(1..members.count)).each do |member|
    Attendance.create!(
      member_id: member.id,
      event_id: event.id
    )
  end
end

puts 'Created sample attendances for each event.'
