FactoryBot.define do
     factory :speaker_event do
          ytLink { 'https://youtube.com/sample' }
          association :event
          association :speaker
     end
end
