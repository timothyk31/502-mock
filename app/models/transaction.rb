class Transaction < ApplicationRecord
     belongs_to :request_member, class_name: 'Member'
     belongs_to :approve_member, class_name: 'Member', optional: true

     has_many :payment_transaction, class_name: 'TransactionPayment', dependent: :destroy
     accepts_nested_attributes_for :payment_transaction, allow_destroy: true

     validates :name, presence: true
     validates :statement_of_purpose, presence: true
     validates :request_member_id, presence: true
     validates :pay_type, presence: true

     enum :pay_type, { cash: 0, credit: 1, debit: 2, paypal: 3 }

     has_one_attached :receipt_picture

     # before_save :compress_receipt_picture

     private

     def compress_receipt_picture
          return unless receipt_picture.attached?

          blob = receipt_picture.blob
          receipt_picture.variant(resize_to_limit: [1024, 1024]).processed
          image = MiniMagick::Image.read(blob.download)
          image.resize '1024x1024'
          image.quality '75'
          image.write blob.service.send(:path_for, blob.key)
     end
end
