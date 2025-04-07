# frozen_string_literal: true

class CreateTransactionPayments < ActiveRecord::Migration[7.0]
     def change
          create_table :transaction_payments do |t|
               t.references :transaction, null: false, foreign_key: true
               t.integer :category, null: false
               t.decimal :amount, precision: 10, scale: 2, null: false

               t.timestamps
          end

          add_index :transaction_payments, %i[transaction_id category], unique: true
     end
end
