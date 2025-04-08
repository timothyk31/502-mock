require 'rails_helper'

RSpec.describe MemberController, type: :controller do
     include Devise::Test::ControllerHelpers

     let(:admin) { create(:member, role: 5) }
     let(:non_admin) { create(:member, role: 1) }
     let(:member) { create(:member, role: 1) }
     let(:event) { create(:event, start_time: 1.day.ago, end_time: 1.hour.ago) }
     let(:attendance) { create(:attendance, member: member, event: event) }

     before do
          sign_in(admin)
     end

     describe 'POST #update' do
          let(:member) { create(:member, first_name: 'John', last_name: 'Doe', email: 'john.doe@example.com', role: 1) }

          context 'when updating a member as an admin' do
               it 'updates the member and sets the role to 5 if admin' do
                    post :update, params: { id: member.id, member: { first_name: 'Jane', role: 5 } }
                    member.reload
                    expect(member.first_name).to eq('Jane')
                    expect(member.role).to eq(5)
               end
          end

          context 'when updating a member as a non-admin' do
               before do
                    sign_out(admin)
                    sign_in(non_admin)
               end

               it 'does not allow updating the role' do
                    post :update, params: { id: member.id, member: { role: 5 } }
                    member.reload
                    expect(member.role).not_to eq(5)
               end
          end
     end

     describe 'GET #list' do
          it 'renders the list of members' do
               get :list
               expect(response).to have_http_status(:success)
          end
     end

     describe 'GET #show' do
          let(:member) { create(:member) }

          it 'shows the member details' do
               get :show, params: { id: member.id }
               expect(response).to have_http_status(:success)
          end
     end

     describe 'GET #search' do
          it 'returns matching members as JSON' do
               create(:member, first_name: 'John', last_name: 'Doe', email: 'john.doe@example.com')
               get :search, params: { query: 'John' }
               expect(response).to have_http_status(:success)
               expect(JSON.parse(response.body).first['first_name']).to eq('John')
          end
     end

     describe 'GET #attendance_chart' do
          it 'returns attendance data for a specific member as JSON' do
               get :attendance_chart, params: { member_id: member.id }
               expect(response).to have_http_status(:success)
               expect(JSON.parse(response.body).first['name']).to eq(event.name)
          end
     end

     describe 'GET #attendance_line' do
          it 'returns attendance counts for events within a date range as JSON' do
               create(:attendance, event: event)
               get :attendance_line, params: { start_time: 2.days.ago, end_time: Time.now }
               expect(response).to have_http_status(:success)
               expect(JSON.parse(response.body).first[0]).to eq(event.name)
               expect(JSON.parse(response.body).first[1]).to eq(1)
          end
     end
end
