FactoryBot.define do
     factory :attendance do
          association :member
          association :event
     end
end
