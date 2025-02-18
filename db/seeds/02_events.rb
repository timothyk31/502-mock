require 'faker'

# Generate sample events
10.times do
  start_time = Faker::Date.forward(days: 30)
  end_time = start_time + rand(2..10).hours
  Event.create!(
    name: Faker::Lorem.sentence(word_count: 3),
    start_time: start_time,
    end_time: end_time,
    location: Faker::Address.full_address,
    attendance_code: Faker::Number.number(digits: 6)
  )
end

puts 'Created 10 sample events.'
