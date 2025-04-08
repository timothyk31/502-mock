FactoryBot.define do
     factory :member do
          email { Faker::Internet.email }
          first_name { Faker::Name.first_name }
          last_name { Faker::Name.last_name }
          uid { SecureRandom.uuid }
          avatar_url { Faker::Avatar.image }
          class_year { 2025 }
          role { 0 }
          phone_number { Faker::Number.number(digits: 10) }
          address { Faker::Address.full_address }
          uin { Faker::Number.number(digits: 9) }
     end
end
