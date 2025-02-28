class CreateTransactions < ActiveRecord::Migration[7.0]
     def change
          create_table :transactions do |t|
               t.string :name
               t.string :statement_of_purpose
               t.decimal :amnt, precision: 10, scale: 2
               t.integer :request_member_id
               t.boolean :approved
               t.integer :approve_member_id
               t.string :response_msg
               t.integer :pay_type

               t.timestamps
          end

          add_foreign_key :transactions, :members, column: :request_member_id
          add_foreign_key :transactions, :members, column: :approve_member_id
     end
end
