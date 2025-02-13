require 'faker'

# Generate sample members
10.times do
  Member.create!(
    email: Faker::Internet.email,
    role: rand(0..4),
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name
  )
end

puts 'Created 10 sample members.'
