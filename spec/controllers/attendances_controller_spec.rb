require 'rails_helper'

RSpec.describe AttendancesController, type: :controller do
     include Devise::Test::ControllerHelpers

     let(:admin) { create(:member, role: 5) }
     let(:member) { create(:member, role: 1) }
     let(:event) { create(:event) }
     let(:attendance) { create(:attendance, member: member, event: event) }

     describe 'GET #show' do
          context 'when user is an admin' do
               before do
                    sign_in admin
                    get :show, params: { id: attendance.id }
               end

               it 'allows access to the attendance' do
                    expect(response).to have_http_status(:success)
               end
          end

          context 'when user is not an admin' do
               before { sign_in member }

               it 'allows access to their own attendance' do
                    get :show, params: { id: attendance.id }
                    expect(response).to have_http_status(:success)
               end

               it 'redirects when trying to access another member\'s attendance' do
                    other_attendance = create(:attendance)
                    get :show, params: { id: other_attendance.id }
                    expect(response).to redirect_to(root_path)
                    expect(flash[:alert]).to eq('You are not authorized to view this page.')
               end
          end
     end

     describe 'POST #create' do
          before { sign_in admin }

          context 'with valid parameters' do
               it 'creates a new attendance' do
                    expect do
                         post :create, params: { attendance: { member_id: member.id, event_id: event.id } }
                    end.to change(Attendance, :count).by(1)
                    expect(response).to redirect_to(assigns(:attendance))
                    expect(flash[:notice]).to eq('Attendance was successfully created.')
               end
          end

          context 'with invalid parameters' do
               it 'renders the new template' do
                    post :create, params: { attendance: { member_id: nil, event_id: event.id } }
                    expect(response).to render_template(:new)
               end
          end
     end

     describe 'PATCH #update' do
          before { sign_in admin }

          it 'updates the attendance and logs the action' do
               patch :update, params: { id: attendance.id, attendance: { member_id: member.id, event_id: event.id } }
               attendance.reload
               expect(attendance.status).to eq('absent')
               expect(response).to redirect_to(attendance)
               expect(flash[:notice]).to eq('Attendance was successfully updated.')
          end
     end

     describe 'DELETE #destroy' do
          before { sign_in admin }

          it 'deletes the attendance and logs the action' do
               attendance # Ensure the attendance is created
               expect do
                    delete :destroy, params: { id: attendance.id }
               end.to change(Attendance, :count).by(-1)
               expect(response).to redirect_to(attendances_url)
               expect(flash[:notice]).to eq('Attendance was successfully destroyed.')
          end
     end

     describe 'GET #non_attendees' do
          before { sign_in admin }

          it 'returns a CSV file of non-attendees' do
               get :non_attendees, params: { event_id: event.id, format: :csv }
               expect(response.content_type).to eq('text/csv')
               expect(response.body).to include('ID,First Name,Last Name,Email,UIN,Class Year,Role,Phone Number,Address,Joined At')
          end
     end

     describe 'GET #verify' do
          let(:event_with_code) { create(:event, attendance_code: '12345', start_time: 1.hour.ago, end_time: 1.hour.from_now) }
          let(:expired_event) { create(:event, attendance_code: '12345', start_time: 2.hours.ago, end_time: 1.hour.ago) }

          context 'with a valid attendance code' do
               before do
                    sign_in member
                    get :verify, params: { event_id: event_with_code.id, attendance_code: '12345' }
               end

               it 'creates a new attendance' do
                    expect(Attendance.exists?(member: member, event: event_with_code)).to be true
                    expect(response).to redirect_to(request.referer)
                    expect(flash[:notice]).to eq('Attendance was successfully created.')
               end
          end

          context 'with an invalid attendance code' do
               before do
                    sign_in member
                    get :verify, params: { event_id: event_with_code.id, attendance_code: 'wrong_code' }
               end

               it 'does not create a new attendance and shows an alert' do
                    expect(Attendance.exists?(member: member, event: event_with_code)).to be false
                    expect(response).to redirect_to(request.referer)
                    expect(flash[:alert]).to eq('Invalid or missing attendance code or event has ended.')
               end
          end

          context 'when the event has ended' do
               before do
                    sign_in member
                    get :verify, params: { event_id: expired_event.id, attendance_code: '12345' }
               end

               it 'does not create a new attendance and shows an alert' do
                    expect(Attendance.exists?(member: member, event: expired_event)).to be false
                    expect(response).to redirect_to(request.referer)
                    expect(flash[:alert]).to eq('Invalid or missing attendance code or event has ended.')
               end
          end
     end

     describe 'Private methods' do
          let(:event) { create(:event, attendance_code: '12345', start_time: 1.hour.ago, end_time: 1.hour.from_now) }

          describe '#find_event' do
               it 'finds the correct event' do
                    sign_in member
                    controller.params = { event_id: event.id }
                    expect(controller.send(:find_event)).to eq(event)
               end
          end

          describe '#valid_attendance_code?' do
               it 'returns true for a valid code and time' do
                    sign_in member
                    expect(controller.send(:valid_attendance_code?, event)).to be true
               end

               it 'returns false for an invalid code' do
                    sign_in member
                    controller.params = { attendance_code: 'wrong_code' }
                    expect(controller.send(:valid_attendance_code?, event)).to be false
               end

               it 'returns false if the event has ended' do
                    expired_event = create(:event, attendance_code: '12345', start_time: 2.hours.ago, end_time: 1.hour.ago)
                    sign_in member
                    expect(controller.send(:valid_attendance_code?, expired_event)).to be false
               end
          end

          describe '#create_attendance' do
               it 'creates a new attendance for the member and event' do
                    sign_in member
                    expect do
                         controller.send(:create_attendance, event)
                    end.to change(Attendance, :count).by(1)
               end

               it 'does not create attendance if save fails' do
                    allow_any_instance_of(Attendance).to receive(:save).and_return(false)
                    sign_in member
                    expect do
                         controller.send(:create_attendance, event)
                    end.not_to change(Attendance, :count)
               end
          end
     end
end
