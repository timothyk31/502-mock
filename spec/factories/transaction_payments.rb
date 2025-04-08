FactoryBot.define do
     factory :transaction_payment do
          association :transaction
          category { :travel }
          amount { 100.00 }
     end
end
