FactoryBot.define do
     factory :event do
          name { 'Sample Event' }
          location { 'Sample Location' }
          start_time { Time.now }
          end_time { Time.now + 2.hours }
          attendance_code { '12345' }
     end
end
