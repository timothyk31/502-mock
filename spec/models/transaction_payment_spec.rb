# frozen_string_literal: true

# spec/models/transaction_payment_spec.rb
require 'rails_helper'

RSpec.describe TransactionPayment, type: :model do
     # Define valid attributes for Member and Transaction
     let(:valid_member_attributes) do
          {
               email: 'member@example.com',
               first_name: 'Alice',
               last_name: 'Smith',
               uid: '987654',
               class_year: 2024,
               role: 0.0
          }
     end

     let(:valid_transaction_attributes) do
          {
               name: 'Conference Expenses',
               statement_of_purpose: 'Event budget',
               pay_type: :cash,
               request_member: Member.create!(valid_member_attributes)
          }
     end

     let!(:transaction) { Transaction.create!(valid_transaction_attributes) }

     describe 'validations' do
          it 'is valid with valid attributes' do
               payment = TransactionPayment.new(
                    category: :travel,
                    amount: 100.0,
                    transaction_id: transaction.id # Use transaction_id instead of payment_transaction
               )
               expect(payment).to be_valid
          end

          it 'is not valid without a category' do
               payment = TransactionPayment.new(
                    amount: 100.0,
                    transaction_id: transaction.id
               )
               expect(payment).not_to be_valid
               expect(payment.errors[:category]).to include("can't be blank")
          end

          it 'is not valid without an amount' do
               payment = TransactionPayment.new(
                    category: :travel,
                    transaction_id: transaction.id
               )
               expect(payment).not_to be_valid
               expect(payment.errors[:amount]).to include("can't be blank")
          end

          it 'is not valid with a non-positive amount' do
               payment = TransactionPayment.new(
                    category: :travel,
                    amount: 0,
                    transaction_id: transaction.id
               )
               expect(payment).not_to be_valid
               expect(payment.errors[:amount]).to include('must be greater than 0')
          end
     end
end
