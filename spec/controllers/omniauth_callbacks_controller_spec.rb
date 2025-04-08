require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do
     describe '#google_oauth2' do
          let(:auth_hash) do
               {
                    'provider' => 'google_oauth2',
                    'uid' => '12345',
                    'info' => {
                         'email' => 'test@example.com',
                         'first_name' => 'Test',
                         'last_name' => 'User',
                         'image' => 'http://example.com/avatar.jpg'
                    }
               }
          end

          before do
               request.env['omniauth.auth'] = OmniAuth::AuthHash.new(auth_hash)
               @request.env['devise.mapping'] = Devise.mappings[:member] # Added to resolve mapping issue
          end

          context 'when the member is found' do
               let(:member) { create(:member, email: 'test@example.com') }

               it 'signs in the member and redirects' do
                    allow(Member).to receive(:from_google).and_return(member)

                    post :google_oauth2

                    expect(flash[:success]).to eq I18n.t('devise.omniauth_callbacks.success', kind: 'Google')
                    expect(response).to redirect_to(root_path)
               end
          end

          context 'when the member is not found' do
               it 'redirects to the sign-in page with an alert' do
                    allow(Member).to receive(:from_google).and_return(nil)

                    post :google_oauth2

                    expect(flash[:alert]).to eq I18n.t('devise.omniauth_callbacks.failure', kind: 'Google',
                                                                                            reason: "#{auth_hash['info']['email']} is not authorized.")
                    expect(response).to redirect_to(new_member_session_path)
               end
          end

          context 'when an exception occurs' do
               it 'handles the exception and redirects with an alert' do
                    allow(Member).to receive(:from_google).and_raise(StandardError, 'Something went wrong')

                    post :google_oauth2

                    expect(flash[:alert]).to eq I18n.t('devise.omniauth_callbacks.failure', kind: 'Google',
                                                                                            reason: 'Something went wrong')
                    expect(response).to redirect_to(new_member_session_path)
               end
          end
     end

     describe '#failure' do
          before do
               @request.env['devise.mapping'] = Devise.mappings[:member]
               allow(controller).to receive(:params).and_return({ strategy: 'google_oauth2', message: 'invalid_credentials' })
          end

          it 'redirects to the sign-in page with an alert' do
               get :failure

               expect(flash[:alert]).to eq I18n.t('devise.omniauth_callbacks.failure', kind: 'GoogleOauth2',
                                                                                       reason: 'invalid_credentials')
               expect(response).to redirect_to(new_member_session_path)
          end
     end

     describe '#after_sign_in_path_for' do
          let(:member) { create(:member, role: role) }

          before do
               @request.env['devise.mapping'] = Devise.mappings[:member]
          end

          context 'when the member has a role >= 5' do
               let(:role) { 5 }

               it 'redirects to the admin path' do
                    expect(controller.send(:after_sign_in_path_for, member)).to eq(admin_path)
               end
          end

          context 'when the member has a role < 5' do
               let(:role) { 4 }

               it 'redirects to the root path' do
                    expect(controller.send(:after_sign_in_path_for, member)).to eq(root_path)
               end
          end
     end
end
