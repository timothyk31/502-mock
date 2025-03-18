class TransactionsController < ApplicationController
     before_action :authenticate_member!
     # before_action :restrict_non_admins
     before_action :set_transaction, only: %i[show edit update destroy]

     def index
          @transactions = Transaction.all
     end

     def show
     end

     def new
          @transaction = Transaction.new
          @transaction.payment_transaction.build
     end

     def edit
     end

     def create
          @transaction = Transaction.new(transaction_params)
          @transaction.request_member = current_member

          puts 'Trying to save transaction...'
          if @transaction.save
               puts 'Transaction was successfully created.'
               redirect_to @transaction, notice: 'Transaction was successfully created.'
          else
               puts 'Transaction was not created.'
               puts @transaction.errors.full_messages
               render :new, status: :unprocessable_entity
          end
     end

     def update
          if @transaction.update(transaction_params)
               redirect_to @transaction, notice: 'Transaction was successfully updated.'
          else
               render :edit, status: :unprocessable_entity
          end
     end

     def destroy
          @transaction = Transaction.find(params[:id])
          @transaction.destroy
          @transaction.payment_transaction.destroy
          redirect_to transactions_url, notice: 'Transaction was successfully destroyed.'
     end

     private

     def set_transaction
          @transaction = Transaction.find(params[:id])
     end

     def transaction_params
          params.require(:transaction).permit(:name, :statement_of_purpose, :approved, :approve_member_id, :response_msg, :pay_type, :receipt_url, payment_transaction_attributes: %i[id category amount _destroy])
     end

     
     # def restrict_non_admins
     #      redirect_to root_path, alert: 'You are not authorized to view this page.' unless current_member.role >= 5
     # end
end
