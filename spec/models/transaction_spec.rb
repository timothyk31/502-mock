# spec/requests/transactions_spec.rb
require 'rails_helper'

RSpec.describe "Transactions", type: :request do
  # Create a test member with all required attributes
  let(:member) do
    Member.create!(
      email: "test@example.com",
      first_name: "John",
      last_name: "Doe",
      uid: "123456",
      class_year: 2023,
      role: 0.0,
      phone_number: "123-456-7890",
      address: "123 Main St",
      uin: "123456789"
    )
  end

  # Create a sample transaction
  let(:valid_attributes) do
    {
      name: "Office Supplies",
      statement_of_purpose: "Purchase stationery",
      pay_type: "cash",
      request_member_id: member.id
    }
  end

  let!(:transaction) { Transaction.create!(valid_attributes) }

  before do
    # Sign in before each test
    sign_in member
  end

  describe "GET /index" do
    it "returns http success" do
      get transactions_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get transaction_path(transaction)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get new_transaction_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new transaction and redirects" do
        expect {
          post transactions_path, params: { transaction: valid_attributes }
        }.to change(Transaction, :count).by(1)
        
        expect(response).to redirect_to(transaction_path(Transaction.last))
      end
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get edit_transaction_path(transaction)
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) do
        { name: "Updated Office Supplies" }
      end

      it "updates the transaction" do
        patch transaction_path(transaction), params: { transaction: new_attributes }
        transaction.reload
        expect(transaction.name).to eq("Updated Office Supplies")
        expect(response).to redirect_to(transaction_path(transaction))
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the transaction" do
      expect {
        delete transaction_path(transaction)
      }.to change(Transaction, :count).by(-1)

      expect(response).to redirect_to(transactions_path)
    end
  end
end