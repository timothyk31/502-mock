FactoryBot.define do
     factory :speaker do
          name { Faker::Name.name }
          details { 'Speaker details' }
          email { Faker::Internet.email }
     end
end
