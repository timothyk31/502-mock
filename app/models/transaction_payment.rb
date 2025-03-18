class TransactionPayment < ApplicationRecord
     belongs_to :payment_transaction, class_name: 'Transaction', optional: true

     enum :category, { travel: 0, food: 1, office_supplies: 2, utilities: 3, membership: 4, services_offer_income: 5, clothing: 6, rent: 7, other_expenses: 8, items_for_resale: 9 }

     validates :category, presence: true
     validates :amount, presence: true, numericality: { greater_than: 0 }
end
