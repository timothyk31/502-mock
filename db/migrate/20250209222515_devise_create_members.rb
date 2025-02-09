# frozen_string_literal: true

class DeviseCreateMembers < ActiveRecord::Migration[7.0]
  def change
    create_table :members do |t|
      t.string :email, null: false
      t.string :first_name
      t.string :last_name
      t.string :uid
      t.string :avatar_url
      t.timestamps null: false

      # Following attributes are not managed by Google Auth
      t.numeric :class_year
      t.numeric :role, default: 0
      t.string :phone_number
      t.string :address
      t.string :uin
    end
    add_index :members, :email, unique: true
  end
end
