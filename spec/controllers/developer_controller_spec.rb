require 'rails_helper'

RSpec.describe DeveloperController, type: :controller do
     include Devise::Test::ControllerHelpers

     let(:admin) { create(:member, role: 5) }
     let(:member) { create(:member, role: 1) }

     before do
          allow(controller).to receive(:current_member).and_return(admin)
          ENV['DEV_EMAIL'] = admin.email
     end

     describe 'GET #index' do
          it 'assigns all members to @members' do
               members = [admin, member]
               get :index
               expect(assigns(:members)).to match_array(members)
          end

          it 'does not assign nil to @members' do
               get :index
               expect(assigns(:members)).not_to be_nil
          end
     end

     describe 'GET #show' do
          it 'assigns all members to @members' do
               members = [admin, member]
               get :show
               expect(assigns(:members)).to match_array(members)
          end

          it 'does not assign nil to @members' do
               get :show
               expect(assigns(:members)).not_to be_nil
          end
     end

     describe 'POST #update_roles' do
          it 'updates the roles of members' do
               post :update_roles, params: { members: { member.id => 5 } }
               expect(member.reload.role).to eq(5)
               expect(response).to redirect_to(developer_index_path)
               expect(flash[:notice]).to eq('Roles updated successfully.')
          end
     end

     describe 'authentication' do
          it 'redirects non-dev users to root_path' do
               allow(controller).to receive(:current_member).and_return(member)
               get :index
               expect(response).to redirect_to(root_path)
               expect(flash[:alert]).to eq('You are not authorized to view this page.')
          end
     end
end
