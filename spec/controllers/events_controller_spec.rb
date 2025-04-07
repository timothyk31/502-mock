require 'rails_helper'

RSpec.describe EventsController, type: :controller do
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

     describe 'POST #create' do
          context 'as an admin' do
               it 'creates a new event' do
                    sign_in admin
                    expect do
                         post :create, params: { event: attributes_for(:event) }
                    end.to change(Event, :count).by(1)
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
