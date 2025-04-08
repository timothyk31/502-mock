require 'rails_helper'

RSpec.describe SpeakersController, type: :controller do
     include Devise::Test::ControllerHelpers

     let(:admin) { create(:member, role: 5) }
     let(:speaker) { create(:speaker) }

     before do
          sign_in admin
     end

     describe 'GET #index' do
          it 'returns a successful response' do
               get :index
               expect(response).to be_successful
          end

          it 'filters speakers by query' do
               create(:speaker, name: 'John Doe', email: 'john@example.com')
               get :index, params: { query: 'John' }
               expect(assigns(:speakers).pluck(:name)).to include('John Doe')
          end
     end

     describe 'GET #show' do
          it 'redirects to speakers_path' do
               get :show, params: { id: speaker.id }
               expect(response).to redirect_to(speakers_path)
          end
     end

     describe 'GET #new' do
          it 'assigns a new speaker' do
               get :new
               expect(assigns(:speaker)).to be_a_new(Speaker)
          end
     end

     describe 'POST #create' do
          context 'with valid attributes' do
               it 'creates a new speaker and redirects' do
                    expect do
                         post :create, params: { speaker: attributes_for(:speaker) }
                    end.to change(Speaker, :count).by(1)
                    expect(response).to redirect_to(speakers_path)
               end
          end

          context 'with invalid attributes' do
               it 'renders the new template' do
                    post :create, params: { speaker: attributes_for(:speaker, name: nil) }
                    expect(response).to render_template(:new)
               end
          end
     end

     describe 'PATCH #update' do
          context 'with valid attributes' do
               it 'updates the speaker and redirects' do
                    patch :update, params: { id: speaker.id, speaker: { name: 'Updated Name' } }
                    expect(speaker.reload.name).to eq('Updated Name')
                    expect(response).to redirect_to(speakers_path)
               end
          end

          context 'with invalid attributes' do
               it 'renders the edit template' do
                    patch :update, params: { id: speaker.id, speaker: { name: nil } }
                    expect(response).to render_template(:edit)
               end
          end
     end

     describe 'DELETE #destroy' do
          it 'deletes the speaker and redirects' do
               speaker_to_delete = create(:speaker)
               expect do
                    delete :destroy, params: { id: speaker_to_delete.id }
               end.to change(Speaker, :count).by(-1)
               expect(response).to redirect_to(speakers_url)
          end
     end

     describe 'authentication' do
          it 'redirects non-admin users to root_path' do
               sign_out admin
               non_admin = create(:member, role: 1)
               sign_in non_admin
               get :index
               expect(response).to redirect_to(root_path)
          end
     end
end
