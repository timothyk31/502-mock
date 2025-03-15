# spec/models/transaction_spec.rb
require 'rails_helper'

RSpec.describe Transaction, type: :model do
  # Define valid attributes for Member and Transaction
  let(:valid_member_attributes) do
    {
      email: "user@example.com",
      first_name: "John",
      last_name: "Doe",
      uid: "123456",
      class_year: 2023,
      role: 0.0
    }
  end

  let(:valid_transaction_attributes) do
    {
      name: "Office Supplies Purchase",
      statement_of_purpose: "Buying stationery",
      pay_type: :cash,
      request_member: Member.create!(valid_member_attributes)
    }
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      transaction = Transaction.new(valid_transaction_attributes)
      expect(transaction).to be_valid
    end

    it 'is not valid without a name' do
      transaction = Transaction.new(valid_transaction_attributes.except(:name))
      expect(transaction).not_to be_valid
      expect(transaction.errors[:name]).to include("can't be blank")
    end

    it 'is not valid without a statement_of_purpose' do
      transaction = Transaction.new(valid_transaction_attributes.except(:statement_of_purpose))
      expect(transaction).not_to be_valid
      expect(transaction.errors[:statement_of_purpose]).to include("can't be blank")
    end

    it 'is not valid without a request_member_id' do
      transaction = Transaction.new(valid_transaction_attributes.except(:request_member))
      expect(transaction).not_to be_valid
      expect(transaction.errors[:request_member]).to include("must exist")
    end

    it 'is not valid without a pay_type' do
      transaction = Transaction.new(valid_transaction_attributes.except(:pay_type))
      expect(transaction).not_to be_valid
      expect(transaction.errors[:pay_type]).to include("can't be blank")
    end
  end

  describe 'associations' do
    it 'belongs to a request_member' do
      association = described_class.reflect_on_association(:request_member)
      expect(association.macro).to eq(:belongs_to)
      expect(association.class_name).to eq("Member")
    end

    it 'belongs to an approve_member (optional)' do
      association = described_class.reflect_on_association(:approve_member)
      expect(association.macro).to eq(:belongs_to)
      expect(association.options[:optional]).to be(true)
    end
  end

  describe 'enums' do
    it 'defines pay_type enum' do
      expect(described_class.pay_types).to eq({
        "cash" => 0,
        "credit" => 1,
        "debit" => 2,
        "paypal" => 3
      })
    end
  end
end