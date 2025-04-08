require 'rails_helper'

RSpec.describe LogsController, type: :controller do
     include Devise::Test::ControllerHelpers

     let(:admin) { create(:member, role: 5) }
     let(:non_admin) { create(:member) }

     describe 'GET #download' do
          context 'when the user is an admin' do
               before do
                    sign_in admin
                    allow(File).to receive(:exist?).and_return(true)
                    allow(File).to receive(:foreach).and_yield("Log line 1\n").and_yield("Log line 2\n")
               end

               it 'returns the log file as an attachment' do
                    get :download

                    expect(response.headers['Content-Disposition']).to include('attachment')
                    expect(response.body).to include('Log line 1', 'Log line 2')
                    expect(response.content_type).to eq('text/plain')
               end

               it 'logs a warning message' do
                    expect(Rails.logger).to receive(:warn).with("User #{admin.id} downloaded the log file")
                    get :download
               end
          end

          context 'when the user is not an admin' do
               before do
                    sign_in non_admin
               end

               it 'restricts access' do
                    expect { get :download }.to raise_error(Pundit::NotAuthorizedError)
               end
          end
     end
end
