require 'rails_helper'

RSpec.describe AdminController, type: :controller do
     include Devise::Test::ControllerHelpers

     let(:admin) { create(:member, role: 5) }
     let(:member) { create(:member, role: 1) }

     before do
          sign_in admin
     end

     describe 'GET #index' do
          it 'allows access for admin and assigns members' do
               get :index
               expect(response).to have_http_status(:success)
               expect(assigns(:members)).to include(member)
          end
     end

     describe 'POST #update_roles' do
          it 'updates roles of members and logs the change' do
               post :update_roles, params: { members: { member.id => 3 } }
               member.reload
               expect(member.role).to eq(3)
               expect(response).to redirect_to(admin_path)
               expect(flash[:notice]).to eq('Roles updated successfully.')
          end
     end

     describe 'authentication' do
          it 'redirects non-admin users' do
               sign_out admin
               sign_in member
               get :index
               expect(response).to redirect_to(root_path)
               expect(flash[:alert]).to eq('Access denied.')
          end
     end
end
