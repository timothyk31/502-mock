require 'rails_helper'

RSpec.describe TransactionsController, type: :controller do
     include Devise::Test::ControllerHelpers

     let(:admin_member) { create(:member, role: 5) }
     let(:non_admin_member) { create(:member, role: 1) }
     let(:transaction) { create(:transaction) }

     describe 'GET #index' do
          context 'when logged in as admin' do
               before do
                    sign_in admin_member
                    get :index
               end

               it 'returns a successful response' do
                    expect(response).to have_http_status(:success)
               end
          end

          context 'when logged in as non-admin' do
               before do
                    sign_in non_admin_member
                    get :index
               end

               it 'returns a successful response' do
                    expect(response).to have_http_status(:success)
               end
          end
     end

     describe 'GET #show' do
          before do
               sign_in admin_member
               get :show, params: { id: transaction.id }
          end

          it 'returns a successful response' do
               expect(response).to have_http_status(:success)
          end
     end

     describe 'GET #new' do
          context 'when logged in as admin' do
               before do
                    sign_in admin_member
                    get :new
               end

               it 'returns a successful response' do
                    expect(response).to have_http_status(:success)
               end

               it 'assigns a new transaction' do
                    expect(assigns(:transaction)).to be_a_new(Transaction)
               end
          end

          context 'when logged in as non-admin' do
               before do
                    sign_in non_admin_member
                    get :new
               end

               it 'redirects to the root path' do
                    expect(response).to redirect_to(root_path)
               end
          end
     end

     describe 'GET #edit' do
          context 'when logged in as admin' do
               before do
                    sign_in admin_member
                    get :edit, params: { id: transaction.id }
               end

               it 'returns a successful response' do
                    expect(response).to have_http_status(:success)
               end

               it 'assigns the requested transaction' do
                    expect(assigns(:transaction)).to eq(transaction)
               end
          end

          context 'when logged in as non-admin' do
               before do
                    sign_in non_admin_member
                    get :edit, params: { id: transaction.id }
               end

               it 'redirects to the root path' do
                    expect(response).to redirect_to(root_path)
               end
          end
     end

     describe 'POST #create' do
          context 'when logged in as admin' do
               before { sign_in admin_member }

               it 'creates a new transaction' do
                    expect do
                         post :create, params: { transaction: attributes_for(:transaction) }
                    end.to change(Transaction, :count).by(1)
               end

               it 'redirects to the created transaction' do
                    post :create, params: { transaction: attributes_for(:transaction) }
                    expect(response).to redirect_to(Transaction.last)
               end
          end

          context 'when logged in as admin with invalid receipt_url' do
               before { sign_in admin_member }

               it 'does not create a new transaction and renders :new' do
                    expect do
                         post :create, params: { transaction: attributes_for(:transaction, receipt_url: 'invalid_url') }
                    end.not_to change(Transaction, :count)

                    expect(response).to render_template(:new)
                    expect(response).to have_http_status(:unprocessable_entity)
               end
          end

          context 'when logged in as non-admin' do
               before { sign_in non_admin_member }

               it 'does not create a new transaction' do
                    expect do
                         post :create, params: { transaction: attributes_for(:transaction) }
                    end.not_to change(Transaction, :count)
               end

               it 'redirects to the root path' do
                    post :create, params: { transaction: attributes_for(:transaction) }
                    expect(response).to redirect_to(root_path)
               end
          end
     end

     describe 'PATCH #update' do
          context 'when logged in as admin' do
               before do
                    sign_in admin_member
                    patch :update, params: { id: transaction.id, transaction: { name: 'Updated Name' } }
               end

               it 'updates the transaction' do
                    expect(transaction.reload.name).to eq('Updated Name')
               end
          end

          context 'when logged in as non-admin' do
               before do
                    sign_in non_admin_member
                    patch :update, params: { id: transaction.id, transaction: { name: 'Updated Name' } }
               end

               it 'does not update the transaction' do
                    expect(transaction.reload.name).not_to eq('Updated Name')
               end
          end
     end

     describe 'DELETE #destroy' do
          context 'when logged in as admin' do
               before do
                    sign_in admin_member
                    delete :destroy, params: { id: transaction.id }
               end

               it 'deletes the transaction' do
                    expect(Transaction.exists?(transaction.id)).to be_falsey
               end
          end

          context 'when logged in as non-admin' do
               before do
                    sign_in non_admin_member
                    delete :destroy, params: { id: transaction.id }
               end

               it 'does not delete the transaction' do
                    expect(Transaction.exists?(transaction.id)).to be_truthy
               end
          end
     end
end
