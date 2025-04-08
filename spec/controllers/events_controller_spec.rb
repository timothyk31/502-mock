require 'rails_helper'

RSpec.describe EventsController, type: :controller do
     include Devise::Test::ControllerHelpers

     let(:admin) { create(:member, role: 5) }
     let(:non_admin) { create(:member, role: 1) }
     let(:event) { create(:event) }

     describe 'GET #index' do
          it 'returns a successful response' do
               sign_in admin
               get :index
               expect(response).to have_http_status(:success)
          end
     end

     describe 'GET #show' do
          it 'returns a successful response' do
               sign_in admin
               get :show, params: { id: event.id }
               expect(response).to have_http_status(:success)
          end
     end

     describe 'GET #attendance_chart' do
          it 'returns attendance data for the selected event' do
               sign_in admin
               event = create(:event)
               member = create(:member)
               create(:attendance, event: event, member: member)

               get :attendance_chart, params: { event_id: event.id }
               expect(response).to have_http_status(:success)
               expect(JSON.parse(response.body)['event']['name']).to eq(event.name)
          end
     end

     describe 'GET #search' do
          it 'returns a list of events matching the query' do
               sign_in admin
               event1 = create(:event, name: 'Event One')
               event2 = create(:event, name: 'Event Two')

               get :search, params: { query: 'Event' }
               expect(response).to have_http_status(:success)
               expect(JSON.parse(response.body).size).to eq(2)
          end
     end

     describe 'GET #popular_events' do
          it 'returns a list of popular events within the given time range' do
               sign_in admin
               event = create(:event, start_time: 1.day.ago, end_time: Time.now)
               create(:attendance, event: event)

               get :popular_events, params: { start_time: 2.days.ago, end_time: Time.now }
               expect(response).to have_http_status(:success)
               expect(JSON.parse(response.body).first[0]).to eq(event.name)
          end
     end

     describe 'POST #create' do
          context 'as an admin' do
               it 'creates a new event with a random attendance code' do
                    sign_in admin
                    expect do
                         post :create, params: { event: attributes_for(:event) }
                    end.to change(Event, :count).by(1)
                    expect(Event.last.attendance_code).not_to be_nil
               end
          end

          context 'as a non-admin' do
               it 'redirects to the root path' do
                    sign_in non_admin
                    post :create, params: { event: attributes_for(:event) }
                    expect(response).to redirect_to(root_path)
               end
          end
     end

     describe 'PATCH #update' do
          context 'as an admin' do
               it 'updates the event' do
                    sign_in admin
                    patch :update, params: { id: event.id, event: { name: 'Updated Name' } }
                    expect(event.reload.name).to eq('Updated Name')
               end
          end

          context 'as a non-admin' do
               it 'redirects to the root path' do
                    sign_in non_admin
                    patch :update, params: { id: event.id, event: { name: 'Updated Name' } }
                    expect(response).to redirect_to(root_path)
               end
          end
     end

     describe 'DELETE #destroy' do
          context 'as an admin' do
               it 'deletes the event' do
                    sign_in admin
                    event
                    expect do
                         delete :destroy, params: { id: event.id }
                    end.to change(Event, :count).by(-1)
               end
          end

          context 'as a non-admin' do
               it 'redirects to the root path' do
                    sign_in non_admin
                    delete :destroy, params: { id: event.id }
                    expect(response).to redirect_to(root_path)
               end
          end
     end
end
