class RemoveAmntFromTransactions < ActiveRecord::Migration[7.0]
  def change
    remove_column :transactions, :amnt, :decimal
  end
end
