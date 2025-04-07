# frozen_string_literal: true

class Transaction < ApplicationRecord
     belongs_to :request_member, class_name: 'Member'
     belongs_to :approve_member, class_name: 'Member', optional: true

     has_many :payment_transaction, class_name: 'TransactionPayment', dependent: :destroy
     accepts_nested_attributes_for :payment_transaction, allow_destroy: true

     validates :name, presence: true
     validates :statement_of_purpose, presence: true
     validates :pay_type, presence: true

     enum :pay_type, { cash: 0, credit: 1, debit: 2, paypal: 3 }

     has_one_attached :receipt_picture
end
