# frozen_string_literal: true

class AddReceiptUrlToTransactions < ActiveRecord::Migration[7.0]
     def change
          add_column :transactions, :receipt_url, :string
     end
end
