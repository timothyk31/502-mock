FactoryBot.define do
     factory :transaction do
          name { 'Sample Transaction' }
          statement_of_purpose { 'Purpose of the transaction' }
          request_member_id { create(:member).id }
          approved { false }
          approve_member_id { nil }
          response_msg { 'Pending' }
          pay_type { :cash }
          receipt_url { 'https://drive.google.com/file/d/your-file-id/view' }
     end
end
